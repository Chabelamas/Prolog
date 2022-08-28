%jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).


%tiene(Nombre, QueTiene).
%unidades(cuantas), recursos(Madera, Alimento, Oro) y edificios(cuantos) 
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).
% … y muchos más tipos pertenecientes a estas categorías.

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).
% … y muchos más también

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).
% … y muchos más también


%% Punto 1
esUnAfano(Jugador1, Jugador2):-
    rating(Jugador1, Rating1),
    rating(Jugador2, Rating2),
    abs(Rating1-Rating2) > 500.

rating(Jugador, Rating):-
    jugador(Jugador, Rating, _).


%% Punto 2
esEfectivo(Unidad1, Unidad2):-
    tiene(_, unidad(Unidad1, _)),
    tiene(_, unidad(Unidad2, _)),
    gana(Unidad1, Unidad2).

esEfectivo(samurai, Unidad):-
    militar(Unidad, _, unica).

gana(samurai, _).
gana(caballeria, arqueria).
gana(arqueria, infanteria).
gana(infanteria, piquero).
gana(piquero, caballeria).


%% Punto 3
alarico(Jugador):-
    soloUnidadDe(infanteria, Jugador).

soloUnidadDe(Unidad, Jugador):-
    tiene(Jugador, unidad(_, _)),
    not((tiene(Jugador, unidad(Tipo, _)), militar(Tipo, _, UnidadJugador), Unidad \= UnidadJugador)).


%% Punto 4
leonidas(Jugador):-
    soloUnidadDe(piquero, Jugador).


%% Punto 5
nomada(Jugador):-
    tiene(Jugador, unidad(_, _)),
    not(tiene(Jugador, edificio(casa, _))).


%% Punto 6
cuantoCuesta(Tipo, Costo):-
    tiene(_, unidad(Tipo, _)),
    valorDeunidad(Tipo, Costo).

cuantoCuesta(Tipo, Costo):-
    tiene(_, edificio(Tipo, _)),
    edificio(Tipo, Costo).

cuantoCuesta(Tipo, costo(100, 0, 50)):-
    esCarretaOUrna(Tipo).

valorDeunidad(Tipo, Costo):-
    militar(Tipo, Costo, _).

valorDeunidad(Tipo, costo(0, 50, 0)):-
    aldeano(Tipo, _).

esCarretaOUrna(carreta).
esCarretaOUrna(urnaMercante).


%% Punto 7
produccion(Tipo, produccion(0, 0, 32)):-
    esCarretaOUrna(Tipo).

produccion(Tipo, Produccion):-
    aldeano(Tipo, Produccion).

produccion(Tipo, produccion(0, 0, Oro)):-
    militar(Tipo, _, _),
    valorOro(Tipo, Oro).

valorOro(keshik, 10).
valorOro(_, 0).


%% Punto 8
produccionTotal(Jugador, ProduccionTotal, Recurso):-
    jugador(Jugador, _, _),
    findall(Produccion, loTieneYProduce(Jugador, Recurso, Produccion), Producciones),
    sum_list(Producciones, ProduccionTotal).

obtenerRecurso(madera, produce(Madera, _, _), Madera).
obtenerRecurso(alimento, produce(_, Alimento, _), Alimento).
obtenerRecurso(oror, produce(_, _, Oro), Oro).

loTieneYProduce(Nombre, Recurso, Produccion):-
    tiene(Nombre, unidad(Tipo, CuantasTiene)),
    produccion(Tipo, ProduccionTotal),
    obtenerRecurso(Recurso, ProduccionTotal, ProduccionRecurso),
    Produccion is ProduccionRecurso * CuantasTiene.


%% Punto 9
estaPeleado(Jugador1, Jugador2):-
    cantidadUnidades(Jugador1, Cantidad),
    cantidadUnidades(Jugador2, Cantidad),
    produccionTodosLosRecursos(Jugador1, Produccion1),
    produccionTodosLosRecursos(Jugador2, Produccion2),
    Diferencia is abs(Produccion1 - Produccion2),
    Diferencia < 100.

cantidadUnidades(Jugador, Cantidad):-
    tiene(Jugador, _),
    findall(Unidad, tiene(aleP, Unidad), esUnidad(Unidad), Unidades),
    length(Unidades, Cantidad).

esUnidad(undad(_,_)).

produccionTodosLosRecursos(Jugador, Produccion):-
    produccionTotal(Jugador, ProduccionMadera, madera),
    ProduccionTotalMadera is ProduccionMadera * 3,
    produccionTotal(Jugador, ProduccionAlimento, alimento),
    ProduccionTotalAlimento is ProduccionAlimento * 2,
    produccionTotal(Jugador, ProduccionOro, oro),
    ProduccionTotalOro is ProduccionOro * 5,
    Produccion is ProduccionTotalOro + ProduccionTotalAlimento + ProduccionTotalMadera.


%% Punto 10
avanzaA(Jugador, Edad):-
    jugador(Jugador, _, _),
    puedeAvanzar(Jugador, Edad).

puedeAvanzar(Jugador, media).

puedeAvanzar(Jugador, feudal):-
    tieneMenosRecursoDe(Jugador, alimento, 500),
    tieneAlgunEdificio(Jugador, casa). % considero que puede tener una casa o mas

puedeAvanzar(Jugador, castillo):-
    tieneMenosRecursoDe(Jugador, alimento, 800),
    tieneMenosRecursoDe(Jugador, oro, 200),
    edificioFeudal(EdificioFeudal),
    tieneAlgunEdificio(Jugador, EdificioFeudal).

puedeAvanzar(Jugador, imperial):-
    tieneMenosRecursoDe(Jugador, alimento, 1000),
    tieneMenosRecursoDe(Jugador, oro, 800),
    tieneAlgunEdificio(Jugador, castillo),
    tieneAlgunEdificio(Jugador, universidad).

tieneMenosRecursoDe(Jugador, Recurso, Valor):-
    tiene(Jugador, TieneRecurso),
    sacarValorRecurso(Recurso, TieneRecurso, Cantidad),
    Cantidad < Valor.

sacarValorRecurso(alimento, recurso(_, Alimento, _), Alimento).
sacarValorRecurso(oro, recurso(_, _, Oro), Oro).

tieneAlgunEdificio(Jugador, TipoDeEdificio):-
    tiene(Jugador, edificio(TipoDeEdificio, _)).

edificioFeudal(herreria).
edificioFeudal(establo).
edificioFeudal(galeriaDeTiro).