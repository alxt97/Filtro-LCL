function varargout = Interfaz_GUI(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interfaz_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Interfaz_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Interfaz_GUI is made visible.
function Interfaz_GUI_OpeningFcn(hObject, eventdata, handles, varargin)

axes(handles.axes1);
[x, map]=imread('Equivalente_circuito.png');
image(x);
colormap(map);
axis off
hold on

load_system('Equivalente_monofasicoControlCorriente');
find_system
%open_system('Equivalente_monofasicoControlCorriente');
%get_param('Equivalente_monofasicoControlCorriente/DC Voltage Source1','DialogParameters')
set_param([gcs,'/DC Voltage Source1'],'Amplitude','400');
set_param([gcs,'/Series RLC Branch4'],'Inductance','0.005');
set_param([gcs,'/Series RLC Branch5'],'Inductance','0.002');
set_param([gcs,'/Series RLC Branch6'],'Capacitance','0.000002');
set_param([gcs,'/breaker_load'],'Value','0');
set_param(gcs,'SimulationCommand','Start');
disp('\\\\\\\\\\\\\LISTO//////////////')
disp('\\\\PUEDES EMPEZAR A SIMULAR////')
% Choose default command line output for Interfaz_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Interfaz_GUI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
set(handles.text7,'String', 0);
set(handles.text12,'String', 0);
set(handles.text14,'String', 0);
mdl = 'Equivalente_monofasicoControlCorriente';
open_system([mdl '/V_I_salida']);
sim(mdl);

set(handles.text7,'String', THD_m);
set(handles.text12,'String', Vrms_m);
set(handles.text14,'String', Irms_m);
guidata(hObject, handles);

function edit1_Callback(hObject, eventdata, handles)
%v = get(hObject,'String');
%set_param([gcs,'/DC Voltage Source1'],'Amplitude',v);
L1_H = str2double(get(hObject,'String'));
L1 = string(L1_H/(10^3));
set_param([gcs,'/Series RLC Branch4'],'Inductance', L1);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
L2_H = str2double(get(hObject,'String'));
L2 = string(L2_H/(10^3));
set_param([gcs,'/Series RLC Branch5'],'Inductance', L2);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
C_F = str2double(get(hObject,'String'));
C = string(C_F/(10^6));
set_param([gcs,'/Series RLC Branch6'],'Capacitance', C);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
mdl_1 = 'Equivalente_monofasicoControlCorriente';
open_system([mdl_1 '/Vsalida_Vg'])
sim(mdl_1)
guidata(hObject, handles)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
set_param([gcs,'/breaker_load'],'Value','1');

function edit4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
set_param([gcs,'/breaker_load'],'Value','0');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
open_system('Equivalente_monofasicoControlCorriente')

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
open_system('TrifasicoControl')
