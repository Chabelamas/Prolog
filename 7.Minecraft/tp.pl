% jugador(Jugador, [Items], Hambre).
jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

% lugar(Lugar, [Jugadores], NivelDeOscuridad).
lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

% comestible(Comida).
comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).


%% Punto 1
% tieneItem(Jugador, Item).
tieneItem(Jugador, Item):-
    jugador(Jugador, ListaItems, _),
    member(Item, ListaItems).

%sePreocupaPorSuSalud(Jugador).
sePreocupaPorSuSalud(Jugador):-
    itemComestible(Jugador, ItemComestible1),
    itemComestible(Jugador, ItemComestible2),
    ItemComestible1 \= ItemComestible2.

% itemComestible(Jugador, ItemComestible).
itemComestible(Jugador, ItemComestible):-
    tieneItem(Jugador, ItemComestible),
    comestible(ItemComestible).

% cantidadDeItem(Jugador, Item, Cantidad).
cantidadDeItem(Jugador, Item, Cantidad):-
    jugador(Jugador, _, _),
    tieneItem(_, Item),
    findall(Item, tieneItem(Jugador, Item), Items),
    length(Items, Cantidad).

%tieneMasDe(JugadorConMasDeEseItem, Item)
tieneMasDe(Jugador, Item):-
    cantidadDeItem(Jugador, Item, Cantidad),
    not((cantidadDeItem(OtroJugador, Item, OtraCantidad), OtraCantidad > Cantidad, OtroJugador \= Jugador)).


%% Punto 2
% hayMonstruos(Lugar).
hayMonstruos(Lugar):-
    lugar(Lugar, _, NivelDeOscuridad), 
    NivelDeOscuridad > 6.

% correPeligro(Jugador).
correPeligro(Jugador):-
    estaEn(Jugador, Lugar),
    hayMonstruos(Lugar).

correPeligro(Jugador):-
    estaHambriento(Jugador).

% estaEn(Jugador, Lugar).
estaEn(Jugador, Lugar):-
    lugar(Lugar, Jugadores, _),
    member(Jugador, Jugadores).

% estaHambriento(Jugador)
estaHambriento(Jugador):-
    jugador(Jugador, _, Hambre),
    Hambre < 4,
    not(itemComestible(Jugador, _)).

% nivelPeligrosidad(Lugar, NivelDePeligrosidad).
nivelPeligrosidad(Lugar, NivelDePeligrosidad):-
    poblacionTotalLugar(Lugar, 0),
    lugar(Lugar, _, NivelDeOscuridad),
    NivelDePeligrosidad is NivelDeOscuridad * 10.

nivelPeligrosidad(Lugar, NivelDePeligrosidad):-
    lugar(Lugar,_,_),
    not(hayMonstruos(Lugar)),
    poblacionTotalLugar(Lugar, CantGente),
    poblacionTotalLugarConHambre(Lugar, CantGenteHambrienta),
    NivelDePeligrosidad is ((CantGenteHambrienta * 100) / CantGente).

% nivelPeligrosidad(Lugar, 100).
nivelPeligrosidad(Lugar, 100):-
    hayMonstruos(Lugar).

% poblacionTotalLugar(Lugar, CantGente).
poblacionTotalLugar(Lugar, CantGente):-
    findall(Jugador, estaEn(Jugador, Lugar), Jugadores),
    length(Jugadores, CantGente).

% poblacionTotalLugarConHambre(Lugar, CantGente).
poblacionTotalLugarConHambre(Lugar, CantGente):-
    findall(Jugador, (estaEn(Jugador, Lugar), estaHambriento(Jugador)), Jugadores),
    length(Jugadores, CantGente).


%% Punto 3
% item(Creacion, Requerimientos).
item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

% puedeConstruir(Jugador, Creacion).
puedeConstruir(Jugador, Creacion):-
    jugador(Jugador, _, _),
    item(Creacion, Elementos),
    forall(member(Elemento, Elementos), tieneElemento(Jugador, Elemento)).

% tieneElemento(Jugador, Elemento).
tieneElemento(Jugador, itemSimple(Item, Cantidad)):-
    cantidadDeItem(Jugador, Item, CantidadDeItem),
    CantidadDeItem >= Cantidad.

tieneElemento(Jugador, itemCompuesto(Elemento)):-
    puedeConstruir(Jugador, Elemento).


%% Punto 4
/*
a. ¿Qué sucede si se consulta el nivel de peligrosidad del desierto? ¿A qué se debe?
Si se consulta en la consola el nivel de peligrosidad del desierto ('nivelPeligrosidad(desierto, NivelDePeligrosidad)'), la respuesta sera 'false'. Esto ocurre debido al concepto de universo cerrado, donde lo desconocido (todo lo que no se encuentra en la base de conocimeintos) se presume falso.

b. ¿Cuál es la ventaja que nos ofrece el paradigma lógico frente a funcional a la hora de realizar una consulta?
La principal ventaja que tiene este paradigma es que nos ofrece todas las alternativas posibles que hagan verdadero al predicado consultado. A diferencia del funcional, en el paradigma logico se trabaja con relaciones las cuales no deben cumplir con el criterio de la 'Unicidad'.
*/    
