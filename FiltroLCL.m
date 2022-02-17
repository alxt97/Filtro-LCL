%CALCULOS PARA EL FILTRO LCL //////////////////////////////////////

%Condiciones iniciales del convertidor
P_tex = input('Ingrese la potencia activa de la red en Watts (Sugerencia: 4000):  ');
P=P_tex;         %potencia activa nominal P=4KW

U_tex = input('Ingrese la tensión de red en Volts (Sugerencia: 380, 220, 110):  ');
U=U_tex;         %voltaje rms de red de linea a linea U=400V 

f_tex = input('Ingrese la frecuencia de red (Sugerencia: 50, 60):  ');
f=f_tex;         %frecuencia de red f=50Hz

fsw=10e3;     %frecuencia de conmutación fsw=10000Hz
fres=2.5e3;   %frecuencia de resonancia fres=2500Hz

%Calculos de tensiones y corrientes
Zb = (U^2)/P;               %Impedancia base
I2max = (sqrt(2/3))*(P/U);  %Corriente maxima de red en Amperes I2max=10A
Vgmax = Zb*I2max;           %Voltaje maximo de red en Vgmax=325V
Iimax = I2max;              %Corriente maxima del convertidor en Amperes Iimax=10A
Lgmax=13e-3;                %Inductancia maxima de red Lgmax=13mH (Para condiciones débiles)
Lgmin=0;                    %Inductancia minima de red Lgmin=0mH
RL=10;                      %Valor en Ohmios de la resistencia de carga

%Calculos del Condensador
Cfmax_ap=(0.05*P)/(2*pi*f*U^2);                   % = 3.97e-6 F  =  4uF
Cfmax_ap1 = ceil(Cfmax_ap*1000000);

Cfmax = Cfmax_ap1/1000000;
Cf =Cfmax/2;                                %Valor del condensador, se selecciona 2uF
txt_1 = 'El valor del Capacitor (Cf) en F es:';
disp(txt_1);
disp(Cf);

%Calculos del Inductor 1
LTmax = 0.1*((U^2)/(2*pi*f*P));                %Inductancia maxima total en Henrys
Vimax = sqrt(Vgmax^2+(LTmax*2*pi*f*I2max)^2);  %Voltaje max de entrada 
Vi = Vimax/0.707;
Vdclink_sin_ap = Vimax*sqrt(3);                %Voltaje DC, se aproxima a 600V

Vdclink_ap = ceil(Vdclink_sin_ap/100);
Vdclink = Vdclink_ap*100;
                           
                               %Corriente de saturación de los inductores
Isat = ceil(Iimax);            %redondear para que sea mayor

Limin = Vdclink/((12*fsw)*(Isat-Iimax));     %Inductancia minima primer ind

Deltaimax = Vdclink/(6*fsw*Limin);
cond_isat = Iimax + (Deltaimax/2);

while cond_isat ==  Isat
    Isat = Isat+1;
    Limin_cond = Vdclink/((12*fsw)*(Isat-Iimax));   %verificar que se culmpla condicion isat
    Limin_cond1 = round(Limin_cond*1000);             %Iimax+(Deltaimax/2) < Isat
    Limin = Limin_cond1/1000;
    
    Deltaimax = Vdclink/(6*fsw*Limin);
    cond_isat = Iimax + (Deltaimax/2);
end    

Li = Limin*2;                                  %Valor del inductor 1, se multiplica por 2 a Limin
txt = 'El valor del Inductor (L1) en H es:';
disp(txt);
disp(Li);

%Calculos del Inductor 2

%Evaluacion de condiciones de la tasa de atenuacion armonica "O"
amax=(LTmax/Limin)-1;                          %constante "a" maximo
a1=(Li*Cf*(2*pi*fsw)^2)-1;                     %calculo de a1
a2=Li+(a1*Lgmax)+(a1*Li);
a3=(Li+(a1*Lgmax))*Li*Cfmax;
b2=Li+(a1*Lgmin)+(a1*Li);
b3=(Li+(a1*Lgmin))*Li*Cf;

O1=((36*Li)-((2*pi*fsw*Li)^2)*Cfmax)/((a3*((2*pi*fsw)^2))-(36*a2));     %Primera condicion
O2=((4*Li)-((2*pi*fsw*Li)^2)*Cf)/((b3*((2*pi*fsw)^2))-(4*b2));          %Segunda condicion
Omin=1/(1+(amax*a1));                                                   %tercera condicion

O1_cond = O1*(-100);
O2_cond = O2*100;
O_ap = ceil(O1_cond);

if O_ap > O1_cond && O_ap < O2_cond
    a=(1+(O_ap/100))/((O_ap/100)*a1);
    L2_ap = a*Li;
    L2_ap1 = ceil(L2_ap*1000);                      %redondear el valor de I2
    
    I_cond = Li + (L2_ap1/1000);                    %condicion de inductancia maxima
    
    while I_cond >= LTmax && O_ap < O2_cond
        O_ap = O_ap +1;
        a=(1+(O_ap/100))/((O_ap/100)*a1);
        L2_ap = a*Li;
        L2_ap1 = ceil(L2_ap*1000);
        I_cond = Li + (L2_ap1/1000);
    end
    
    L2 = a*Li;                                       %Valor de inductor 2
    txt_2 = 'El valor del Inductor (L2) en H es:';
    disp(txt_2);
    disp(L2); 
    
else
    a = 'escoger un porcentaje adecuado para O dentro del rango de O1 y O2';
    disp(a);
end

%Calcular funcion de transferencia con simulink//////////////////////////////////////////
mdl = 'Equivalente_monofasicoOpenLoop';
%open_system(mdl) %abrir el modelo de simulink
io(1) = linio('Equivalente_monofasicoOpenLoop/Square Wave Generator',1,'input');

io(2) = linio('Equivalente_monofasicoOpenLoop/PS-Simulink Converter',1,'openoutput');

linsys1 = linearize(mdl,io);

txt_3 = 'La funcion de transferencia para el sistema en lazo abierto es:';
disp(txt_3);
H_s = tf(linsys1)

%Bode y respuesta de la funcion de transferencia
%figure(1)
%bode(linsys1)           %Mostrar el bode de la ft creada

%figure(2)
%step(H_s)
 
%figure(3)
%impulse(H_s)

%figure(4)
%rlocus(H_s)

