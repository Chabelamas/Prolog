%% BASE DE DATOS
% aeropuerto(Aeropuerto, Ciudad).
aeropuerto(aep, buenosAires).
aeropuerto(eze, buenosAires).
aeropuerto(gru, saoPablo).
aeropuerto(scl, santiagoDeChile).

% ciudad(Ciudad, Pais).
ciudad(buenosAires, argentina).
ciudad(saoPablo, brasil).
ciudad(santiagoDeChile, chile).
ciudad(palawan, filipinas).
ciudad(chicago, estadosUnidos).
ciudad(paris, francia).
ciudad(doha, qatar).

% paisAeropuerto(Aeropuerto, Pais).
paisAeropuerto(Aeropuerto, Pais):-    
    aeropuerto(Aeropuerto, Ciudad),
    ciudad(Ciudad, Pais).

% seCaracteriza(Ciudad, Tipo).
seCaracteriza(palawan, paradisiaca).
seCaracteriza(chicago, negocios).
seCaracteriza(paris,  importanciaCultural).
seCaracteriza(buenosAires, importanciaCultural).
seCaracteriza(Ciudad, negocios):-
    ciudad(Ciudad, qatar).

% lugaresEmblematicos(Ciudad, ListaLugares).
lugaresEmblematicos(paris, [torreEiffel, arcoDelTriunfo, museoLouvre, catedralDeNotreDame]).
lugaresEmblematicos(buenosAires, [obelisco, congreso, cabildo]).

% vuelo(aerolinea(Nombre, Partida, Llegada), Costo).
vuelo(aerolinea(aerolineasProlog, aep, gru), 75000).
vuelo(aerolinea(aerolineasProlog, gru, scl), 65000).

% persona(Cliente, Plata, Millas, CiudadInicio).
persona(eduardo, 5000, 750, buenosAires).


%% SABER SI UN VUELO ES DE CABOTAJE
% esDeCabotaje(aerolinea(Nombre, Partida, Llegada)).
esDeCabotaje(aerolinea(Nombre, Partida, Llegada)):-
    vuelo(aerolinea(Nombre, _, _), _),
    forall(vuelo(aerolinea(Nombre, Partida, Llegada), _), vueloEnElMismoPais(Partida, Llegada)).

% vueloEnElMismoPais(Partida, Llegada).
vueloEnElMismoPais(Partida, Llegada):-
    paisAeropuerto(Partida, Pais),
    paisAeropuerto(Llegada, Pais).

%% SABER SI UN VUELO ES SOLO DE IDA
% vueloSoloDeIda(Ciudad).
vueloSoloDeIda(Ciudad):-
    aeropuerto(Aeropuerto, Ciudad),
    vuelo(aerolinea(_, _, Aeropuerto), _),
    not(vuelo(aerolinea(_, Aeropuerto, _), _)).


%% SABER SI UN VUELO ES RELATIVAMENTE DIRECTO
% vueloRelativamenteDirecto(Inicio, Destino).
vueloRelativamenteDirecto(Inicio, Destino):-
    vuelo(aerolinea(_, Inicio, Destino), _).

vueloRelativamenteDirecto(Inicio, Destino):-
    vuelo(aerolinea(Nombre, Inicio, Escala), _),
    vuelo(aerolinea(Nombre, Escala, Destino),_).


%% SABER SI UN CLIENTE PUEDE VIAJAR
% puedeViajar(Cliente, CiudadDestino).
puedeViajar(Cliente, CiudadDestino):-
    persona(Cliente, _, _, CiudadInicio),
    viajeEntreCiudades(CiudadInicio, CiudadDestino, Vuelo),
    puedePagar(Cliente, Vuelo).

% viajeEntreCiudades(CiudadInicio, CiudadDestino, Vuelo).
viajeEntreCiudades(CiudadInicio, CiudadDestino, aerolinea(Nombre, AeropuertoInicio, AeropuertoDestino)):-
    aeropuerto(AeropuertoInicio, CiudadInicio),
    aeropuerto(AeropuertoDestino, CiudadDestino),
    vuelo(aerolinea(Nombre, AeropuertoInicio, AeropuertoDestino), _).

% puedePagar(Cliente, Vuelo).
puedePagar(Cliente, Vuelo):-
    vuelo(Vuelo, Costo),
    persona(Cliente, Plata, _, _),
    Plata >= Costo.

puedePagar(Cliente, Vuelo):-
    vuelo(Vuelo, Costo),
    persona(Cliente, _, Millas, _),
    valorViajeMillas(Vuelo, ValorMillas, Costo),
    ValorMillas =< Millas.

% valorViajeMillas(Vuelo, ValorMillas, Costo).
valorViajeMillas(aerolinea(_, Partida, Llegada), 500, _):-
    vueloEnElMismoPais(Partida, Llegada).

valorViajeMillas(aerolinea(_, Partida, Llegada), ValorMillas, Costo):-
    not(vueloEnElMismoPais(Partida, Llegada)),
    ValorMillas is (Costo * 0.2). 


%% SABER SI UN CLIENTE QUIERE VIAJAR A UN DESTINO
% quiereViajar(Cliente, CiudadDestino).
quiereViajar(Cliente, CiudadDestino):-
    persona(Cliente, Plata, Millas, _),
    Plata > 5000,
    Millas > 100,
    cumpleRequisitoCiudad(CiudadDestino). 

% cumpleRequisitoCiudad(CiudadDestino).
cumpleRequisitoCiudad(CiudadDestino):-
    seCaracteriza(CiudadDestino, paradisiaca).

cumpleRequisitoCiudad(Ciudad):-
    seCaracteriza(Ciudad, importanciaCultural),
    lugaresEmblematicos(Ciudad, LugaresEmblematicos),
    length(LugaresEmblematicos, Cantidad),
    Cantidad > 3.

cumpleRequisitoCiudad(Ciudad):-
    ciudad(Ciudad, qatar).


%% SABER SI UNA PERSONA TIENE QUE AHORRAR PARA VIAJAR AL DESTINO
% tieneQueAhorrar(Cliente, CiudadDestino).
tieneQueAhorrar(Cliente, CiudadDestino):-
    persona(Cliente, _, _, CiudadInicio),
    vueloMasBarato(CiudadInicio, CiudadDestino, Vuelo),
    puedePagar(Cliente, Vuelo).

% vueloMasBarato(CiudadInicio, CiudadDestino, Vuelo).
vueloMasBarato(CiudadInicio, CiudadDestino, Vuelo):-
    viajeEntreCiudades(CiudadInicio, CiudadDestino, Vuelo),
    vuelo(Vuelo, Costo),
    not((viajeEntreCiudades(CiudadInicio, CiudadDestino, OtroVuelo), 
        vuelo(OtroVuelo, OtroCosto), OtroCosto < Costo)).