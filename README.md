# Filtro-LCL
Simulación de un convertidor de potencia conectado a la red mediante un filtro LCL

Los archivos que se encuentran son los siguientes:

- El archivo "FiltroLCL.m" contiene un programa para calcular automaticamente un filtro LCL introduciendo tres valores de entrada
- Los archivos "Equivalente_monofasicoControl110.slx", "Equivalente_monofasicoControlCorriente.slx", "TrifasicoControl.slx" son simulaciones en simulink de convertidores 
  conectados a tres redes diferentes (110V, 220V, 380V)
- El archivo "Interfaz_GUI.m" contiene una interfaz grafica que permite visualizar directamente las graficas de resultados de la simulacion del convertidor conectado a la red 
  de 220V y tambien permite variar los parametros del filtro y observar los cambios que se producen en los resultados
