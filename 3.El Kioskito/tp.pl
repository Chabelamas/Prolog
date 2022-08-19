% atiende(Nombre, Dia, horario(Comienzo, Fin)).
atiende(dodain, lunes, horario(9, 15)). 
atiende(dodain, miercoles, horario(9, 15)). 
atiende(dodain, viernes, horario(9, 15)). 
atiende(lucas, martes, horario(10, 20)).
atiende(juanC, sabado, horario(18, 22)).
atiende(juanC, domingo, horario(18, 22)).
atiende(juanFdS, jueves, horario(10, 20)).
atiende(juanFdS, viernes, horario(12, 20)).
atiende(leoC,lunes, horario(14, 18)).
atiende(leoC,miercoles, horario(14, 18)).
atiende(martu,miercoles, horario(23, 24)).


%% Punto 1
atiende(vale, Dia, Horas):-
  atiende(dodain, Dia, Horas).
atiende(vale, Dia, Horas):-
  atiende(juanC, Dia, Horas).

/*
LeoC no es añadido a la base de conocimientos debido al principio de universo cerrado, solamente se describen hechos en la base de conocimiento.
Maiu al pensando en hacer los nuevos turnos, no se deben poner en la base de conocimiento. Esto ocurre gracias al  principio de universo cerrado, donde lo desconocido se presume falso.
*/

%% Punto 2
% quienesAtienden(Persona, Dia, Hora).
quienesAtienden(Persona, Dia, Hora):-
  atiende(Persona, Dia, horario(Comienzo, Fin)),
  between(Comienzo, Fin, Hora).


%% Punto 3
% foreverAlone(Persona, Dia, Hora)
foreverAlone(Persona, Dia, Hora):-
  quienesAtienden(Persona, Dia, Hora),
  atiende(OtraPersona, _, _), 
  not((quienesAtienden(OtraPersona, Dia, Hora), Persona \= OtraPersona)).

%% Punto 4
% podrianEstarAtendiendo(Dia, Personas).
podrianEstarAtendiendo(Dia, Personas) :-
  findall(Persona, atiende(Persona, Dia, _), PersonasPosiblesRepetidas),
  list_to_set(PersonasPosiblesRepetidas, PersonasPosibles),
  combinar(PersonasPosibles, Personas). 

% combinar(PersonasPosibles, Personas).
combinar([], []).
combinar([Persona|PersonasPosibles], [Persona|Personas]) :-
  combinar(PersonasPosibles, Personas).
combinar([_|PersonasPosibles], Personas) :-
  combinar(PersonasPosibles, Personas).

/*
b. Qué conceptos en conjunto resuelven este requerimiento
- findall como herramienta para poder generar un conjunto de soluciones que satisfacen un predicado
- mecanismo de backtracking de Prolog permite encontrar todas las soluciones posibles
*/


%% Punto 5
% golosina(Precio).
% cigarrillo([Marca]).
% bebidas(conAlcohol/ sinAlcohol, Cantidad).

% ventas(Persona, Dia(Numero, Mes), Ventas).
ventas(dodain, lunes(10, 8), [golosina(1200), cigarrillos([jockey]), golosina(50)]).
ventas(dodain, miercoles(12, 8), [bebidas(conAlcohol, 8), bebidas(sinAlcohol, 1), golosina(10)]).
ventas(martu, miercoles(12, 8),[golosina(1000), cigarrollos([chesterfield, colorado, parisiennes])]).
ventas(lucas, martes(11, 8), [golosina(600)]).
ventas(lucas, martes(18, 8), [bebida(sinAlcohol, 2), cigarrillos([derby])]).

% esSuertuda(Persona).
esSuertuda(Persona):-
  ventas(Persona, _, _),
  forall(ventas(Persona, _, [Venta|_]), ventaImportante(Venta)).

% ventaImportante(Venta).
ventaImportante(golosina(Precio)):-
  Precio > 100.

ventaImportante(cigarrollos(Marcas)):-
  length(Marcas, CantMarcas),
  CantMarcas > 2.

ventaImportante(bebidas(conAlcohol, _)).

ventaImportante(bebidas(sinAlcohol, Cantidad)):-
  Cantidad > 5.