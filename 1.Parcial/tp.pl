
herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).


%% Punto 1
% tieneHerramienta(Persona, Herramienta). 
tieneHerramienta(egon, aspiradora(200)).
tieneHerramienta(egon, trapeador).
tieneHerramienta(peter, trapeador).
tieneHerramienta(winston, varitaNeutrones).

%% Punto 2
% satisfaceNecesidad(Persona,HerramientaRequerida).
satisfaceNecesidad(Persona, HerramientaRequerida):-
  tieneHerramienta(Persona, HerramientaRequerida).

satisfaceNecesidad(Persona, aspiradora(NumeroRequerido)):-
  tieneHerramienta(Persona, aspiradora(Numero)),
  between(0, Numero, NumeroRequerido).

%% Punto 3
% puedeHacerTarea(Persona, Tarea).
puedeHacerTarea(Persona, Tarea):-
  herramientasRequeridas(Tarea, _),
  tieneHerramienta(Persona, varitaNeutrones).

puedeHacerTarea(Persona, Tarea):-
  member(Herramienta, ListaRemplazables),
	satisfaceNecesidad(Persona, Herramienta).


/* OPCION NOSOTROS, SIRVE PARA PUNTO 6 */
puedeHacerTarea(Persona, Tarea):-
	tieneHerramienta(Persona, _),
	herramientasRequeridas(Tarea, _),
	forall((herramientasRequeridas(Tarea, ListaDeHerramientas), member(Herramienta, ListaDeHerramientas)), satisfaceNecesidad(Persona, Herramienta)).


%% Punto 4
tareaPedida(Cliente, Tarea, CantMetrosCuadrado).
precio(Tarea, PrecioMetroCuadrado).

% cobrar(Cliente, Precio).
cobrar(Cliente, PrecioACobrar):-
	tareaPedida(Cliente, _, _),
	findall(Precio, precioPorTarea(Cliente, _, Precio),	ListaPrecios),
	sumlist(ListaPrecios, PrecioACobrar).

precioPorTarea(Cliente, Tarea, Precio):-
	tareaPedida(Cliente, Tarea, Metros),
	precio(Tarea, PrecioPorMetro),
	Precio is PrecioPorMetro * Metros. 


%% Punto 5
% aceptaPedido(Cliente, Trabajador).
aceptaPedido(Cliente, Trabajador):-
  tieneHerramienta(Trabajador, _),
  tareaPedida(Cliente, _, _),
  estaDispuesto(Trabajador, Cliente).

% estaDispuesto(Trabajador, Cliente).
estaDispuesto(ray, Cliente):-
  forall(tareaPedida(Cliente, Tarea, _), Tarea \= limpiarTecho).

estaDispuesto(winston, Cliente):-
  cobrar(Cliente, PrecioACobrar),
  PrecioACobrar > 500.

estaDispuesto(egon, Cliente):-
  not((tareaPedida(Cliente, Tarea, _), tareaCompleja(Tarea))).

estaDispuesto(peter, _).

% tareaCompleja(Tarea).
tareaCompleja(Tarea):-
  herramientasRequeridas(Tarea, HerramientasRequeridas),
  length(HerramientasRequeridas, Cantidad),
  Cantidad > 2.

tareaCompleja(limpiarTecho).


%% Punto 6
/* A. Para agregar una alternativa a un predicado, como un "o", solo es necesario agregar un predicado nuevo */
/* B. Con el predicado agregado en el punto A, sobre herramientas requeridas, no es necesario realizar cambios en nuestra solución, ya que se hicieron las abstracciones necesarias para que no afecte agregar herramientas nuevas */
% herramientasRequeridas(ordenarCuarto, [escoba, trapeador, plumero]).
/* C. Este predicado es facil de agregar gracias al polimorfismo.*/
