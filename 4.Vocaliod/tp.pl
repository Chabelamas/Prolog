% Vocaloid

% vocaloid(Nombre, cancion(NombreCancion, Duracion)).
vocaloid(megurineLuka, cancion(nightFever, 4)).
vocaloid(megurineLuka, cancion(foreverYoung, 5)).
vocaloid(hatsuneMiku, cancion(tellYourWorld, 4)).
vocaloid(gumi, cancion(foreverYoung,4)).
vocaloid(gumi, cancion(tellYourWorld,5)).
vocaloid(seeU, cancion(novemberRain,6)).
vocaloid(seeU, cancion(nightFever,5)).


%% Punto 1
% esNovedoso(Nombre).
esNovedoso(Nombre) :-
    sabeAlMenosDosCanciones(Nombre),
    duracionShow(Nombre, Tiempo),
    Tiempo < 15.
    
sabeAlMenosDosCanciones(Nombre) :-
    vocaloid(Nombre, UnaCancion),
    vocaloid(Nombre, OtraCancion),
    UnaCancion \= OtraCancion.
    
duracionShow(Nombre, TiempoTotal) :-
    findall(TiempoCancion, vocaloid(Nombre,cancion(_, TiempoCancion)), Tiempos),
    sum_list(Tiempos,TiempoTotal).


%% Punto 2
% esAcelerado(Nombre).
esAcelerado(Nombre) :-
    vocaloid(Nombre, _),
    not((vocaloid(Nombre,cancion(_,Duracion)), Duracion > 4)).

%% Punto 3
% concierto(NombreConcierto, Pais, Fama, Tipo(Informacion)).
% concierto(NombreConcierto, Pais, Fama, gigante(CantMinimaCanciones, DuracionTotalMinima)).
% concierto(NombreConcierto, Pais, Fama, mediano(DuracionTotalMaxima)).
% concierto(NombreConcierto, Pais, Fama, pequeno(DuracionMinimaDeUnaCancion)).

concierto(mikuExpo, estadosUnidos, 2000, gigante(2,6)).
concierto(magicalMirai, japon, 3000, gigante(3,10)).
concierto(vocalektVisions,estadosUnidos,1000,mediano(9)).
concierto(mikuFest,argentina,100, pequeno(4)).

%% Punto 4
% puedeParticipar(Nombre, Concierto).
puedeParticipar(hatsuneMiku, NombreConcierto) :-
    concierto(NombreConcierto, _, _, _).

puedeParticipar(Nombre, NombreConcierto) :-
    vocaloid(Nombre, _),
    concierto(NombreConcierto, _, _, Requisitos),
    cumpleRequisitos(Nombre, Requisitos).

% cumpleRequisitos(Nombre, Requisitos).
cumpleRequisitos(Nombre, pequeno(DuracionMinimaDeUnaCancion)) :-
    vocaloid(Nombre, cancion(_, Duracion)),
    Duracion > DuracionMinimaDeUnaCancion.

cumpleRequisitos(Nombre, mediano(DuracionTotalMaxima)) :-
    duracionShow(Nombre, DuracionTotal),
    DuracionTotal < DuracionTotalMaxima.

cumpleRequisitos(Nombre, gigante(CantMinimaCanciones,DuracionTotalMinima)) :-
    cantidadCanciones(Nombre,Cantidad),
    Cantidad > CantMinimaCanciones,
    duracionShow(Nombre,DuracionTotal),
    DuracionTotal > DuracionTotalMinima.
    
% cantidadCanciones(Nombre,Cantidad).
cantidadCanciones(Nombre,Cantidad) :-
    vocaloid(Nombre,_),
    findall(Cancion, vocaloid(Nombre,cancion(Cancion, _)), Canciones),
    length(Canciones,Cantidad).

%% Punto 5
% masFamoso(Nombre).
masFamoso(Nombre) :-
    vocaloid(Nombre,_),
    nivelFama(Nombre, NivelFama),
    not((vocaloid(NombreOtro,_), Nombre \= NombreOtro, nivelFama(NombreOtro, NivelFamaOtro), NivelFamaOtro > NivelFama)).

% nivelFama(Nombre, NivelFama).
nivelFama(Nombre, NivelFama) :-
    cantidadCanciones(Nombre, CantCancionesQueSabe),
    famaTotal(Nombre, FamaTotal),
    NivelFama is FamaTotal * CantCancionesQueSabe.

% famaTotal(Nombre, FamaTotal).
famaTotal(Nombre, FamaTotal):-
    findall(Fama, (puedeParticipar(Nombre, NombreConcierto), concierto(NombreConcierto, _, Fama, _)), Famas),
    sum_list(Famas, FamaTotal).

%% Punto 6
% conoce(vocaloid1, vocaloid2).
conoce(magurineLuka, hatsuneMiku).
conoce(magurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

% participaSinAmigos(Nombre, Concierto)
participaSinAmigos(Nombre, Concierto) :-
    puedeParticipar(Nombre, Concierto),
    not((esConocido(Nombre, Conocido), puedeParticipar(Conocido, Concierto))).

% Conocido directo
esConocido(Nombre, Conocido):-
    conoce(Nombre, Conocido).

% Conocido indirecto
esConocido(Nombre, Conocido):-
    conoce(Nombre, OtroConocido),
    esConocido(OtroConocido, Conocido).

%% Punto 7
/*
Para que todo siga funcionando, se debería agregar una cláusula del predicado cumpleRequisitos que tenga en cuenta los requisitos que se deben cumplir para poder participar de este nuevo tipo de concierto.
El concepto de 'polimorfismo' facilita esta implementación, ya que nos permite tratar de distinta manera a cada tipo de concierto, que tienen distintos requisitos.
*/