%CALCULOS PARA EL FILTRO LCL //////////////////////////////////////

%Condiciones iniciales del convertidor
P=4e3;        %potencia activa nominal P=4KW
U=400;        %voltaje del inversor de entrada U=400V 
f=50;         %frecuencia de red f=50Hz
fsw=10e3;     %frecuencia de conmutación fsw=10000Hz
fres=2.5e3;   %frecuencia de resonancia fres=2500Hz
Vgmax=325;    %Voltaje maximo de red en Vgmax=325V
I2max=10;     %Corriente maxima de red en Amperes I2max=10A
Isat=12;      %Corriente de saturación de los inductores
Iimax=10;     %Corriente maxima del convertidor en Amperes Iimax=10A
Deltaimax=4;  %Variacion de corriente maxima DImax= 4A
Lgmax=13e-3;  %Inductancia maxima de red Lgmax=13mH (Para condiciones débiles)
Lgmin=0;      %Inductancia minima de red Lgmin=0mH
RL=10;        %Valor en Ohmios de la resistencia de carga
Rf=220;       %Voltaje de Referencia o Setpoint del controlador
hmax = 0.50;  %Armonico maximo de voltaje del convertidor
hmin = 0.035 ;%Armonico minimo de voltaje del lado de la red

%Calculos del Condensador
Cfmax=(0.05*P)/(2*pi*f*U^2);                   % = 3.97e-6 F  =  4uF
Cf =Cfmax/2;                                %Valor del condensador, se selecciona 2uF
txt_1 = 'El valor del Capacitor (Cf) en F es:';
disp(txt_1);
disp(Cf);

%Calculos del Inductor 1
LTmax = 0.1*((U^2)/(2*pi*f*P));                %Inductancia maxima total en Henrys
Vimax = sqrt(Vgmax^2+(LTmax*2*pi*f*I2max)^2);  %Voltaje max de entrada 
Vdclink = Vimax*sqrt(3);                       %Voltaje DC, se aproxima a 600V

if Vdclink <= 600 && Vdclink >= 550
    Vdclinkap = 600;
end

if Vdclink <= 550 && Vdclink >= 500
    Vdclinkap = 500;
end

Limin = Vdclinkap/((12*fsw)*(Isat-Iimax));     %Inductancia minima primer ind
Li = Limin*2;                                  %Valor del inductor 1, se selecciona 5mH
txt = 'El valor del Inductor (L1) en H es:';
disp(txt);
disp(Li);

%Calculos del Inductor 2
amax=(LTmax/Limin)-1;                          %constante "a" maximo
a1=(Limin*Cfmax*(2*pi*fsw)^2)-1;               %calculo de a1
Omin=1/(1+(amax*a1));                          %tasa de atenuacion armonica en porcentaje = 0.63%  
ai=(1+Omin)/(Omin*a1);                         %constante "a" 
L2i=ai*Limin;                                  %primera aproximaxion de L2

%Evaluacion de condiciones de la tasa de atenuacion armonica "O"
a2=Li+(a1*Lgmax)+(a1*Li);
a3=(Li+(a1*Lgmax))*Li*Cfmax;
b2=Li+(a1*Lgmin)+(a1*Li);
b3=(Li+(a1*Lgmin))*Li*Cf;

O1=((36*Li)-((2*pi*fsw*Li)^2)*Cfmax)/((a3*((2*pi*fsw)^2))-(36*a2));     %Primera condicion
O2=((4*Li)-((2*pi*fsw*Li)^2)*Cf)/((b3*((2*pi*fsw)^2))-(4*b2));          %Segunda condicion

%PARA DISEÑAR OTRO FILTRO VARIAR EL VALOR DE "O" EN PORCENTAJE, Ej: O=0.09
O=((hmax/hmin)/2)/100;                %Atenuacion armonica igual a 7%
%O=0.11;
a=(1+O)/(O*a1);                       %Se recalcula "a"

if O > O1 && O < O2
    L2=a*Li;                          %Valor de inductor 2
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

figure(1)
bode(linsys1)           %Mostrar el bode de la ft creada

figure(2)
step(H_s)
 
figure(3)
impulse(H_s)

figure(4)
rlocus(H_s)

