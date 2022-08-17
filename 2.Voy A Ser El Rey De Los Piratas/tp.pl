% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).
tripulante(law, heart).
tripulante(bepo, heart).
tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% Relaciona Pirata, Evento y Monto
impactoEnRecompensa(luffy,arlongPark, 30000000).
impactoEnRecompensa(luffy,baroqueWorks, 70000000).
impactoEnRecompensa(luffy,eniesLobby, 200000000).
impactoEnRecompensa(luffy,marineford, 100000000).
impactoEnRecompensa(luffy,dressrosa, 100000000).
impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).
impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).
impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).
impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).
impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).
impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo,240000000).
impactoEnRecompensa(law, dressrosa, 60000000).
impactoEnRecompensa(bepo,sabaody,500).
impactoEnRecompensa(arlong, llegadaAEastBlue,20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).


%% Punto 1
% comparteEvento(Tripulacion1, Tripulacion2, Evento). 
comparteEvento(Tripulacion1, Tripulacion2, Evento):-
  participoEnEvento(Tripulacion1, Evento),
  participoEnEvento(Tripulacion2, Evento),
  Tripulacion1 \= Tripulacion2.

% participoEnEvento(Tripulacion, Evento).
participoEnEvento(Tripulacion, Evento):-
 tripulante(Pirata, Tripulacion),
 impactoEnRecompensa(Pirata, Evento, _).


%% Punto 2
% destacadoEnEvento(Pirata, Evento).
destacadoEnEvento(Pirata, Evento):-
  impactoEnRecompensa(Pirata, Evento, Recompensa),
  forall((impactoEnRecompensa(OtroPirata,Evento,OtraRecompensa),Pirata \= OtroPirata), OtraRecompensa < Recompensa).   


%% Punto 3
% pasaDesapercibido(Pirata, Evento).
pasaDesapercibido(Pirata, Evento):-
  tripulante(Pirata, Tripulacion),
  participoEnEvento(Tripulacion, Evento),
  not(impactoEnRecompensa(Pirata, Evento, _)).

%% Punto 4
% recompensaTotal(Tripulacion, Recompensa).
recompensaTotal(Tripulacion, Recompensa):-
  tripulante(_, Tripulacion),  
  findall(RecompensaActual, (tripulante(Pirata, Tripulacion), recompensaActual(Pirata, RecompensaActual)), Recompensas),
  sum_list(Recompensas, Recompensa).

% recompensaActual(Pirata, Recompensa).
recompensaActual(Pirata, Recompensa):-
  tripulante(Pirata, _),  
  findall(Recompensa1, impactoEnRecompensa(Pirata, _, Recompensa1), Recompensas),
  sum_list(Recompensas, Recompensa).


%% Punto 5
% esTemible(Tripulacion).
esTemible(Tripulacion):-
  tripulante(_, Tripulacion),
  not((tripulante(Pirata, Tripulacion), not(esPeligroso(Pirata)))).

esTemible(Tripulacion):-
  recompensaTotal(Tripulacion, Recompensa),
  Recompensa > 500000000.

/* Opcion Extra
esTemible(Tripulacion):-
  tripulante(_, Tripulacion),
  condicion(Tripulacion).

condicion(Tripulacion):-
  not((tripulante(Pirata, Tripulacion), not(esPeligroso(Pirata)))).

condicion(Tripulacion):-
  recompensaTotal(Tripulacion, Recompensa),
  Recompensa > 500000000.
*/

% esPeligroso(Pirata).
esPeligroso(Pirata):-
  recompensaActual(Pirata, Recompensa), 
  Recompensa > 100000000.

esPeligroso(Pirata):-
  comio(Pirata, Fruta),
  esPeligrosa(Fruta).


%% Punto 6 a)
% comio(Pirata, fruta(paramecia, Nombre)).
% comio(Pirata, fruta(zoan, Nombre, Transformacion)).
% comio(Pirata, fruta(logia, Nombre, Transformacion)).
comio(luffy, fruta(paramecia, gomugomu)).
comio(buggy, fruta(paramecia, barabara)).    
comio(law, fruta(paramecia, opeope)).
comio(chopper, fruta(zoan, hitohito, humano)).
comio(lucci, fruta(zoan, nekoneko, leopardo)).
comio(smoker, fruta(logia, mokumoku, humo)).

% esPeligrosa(Fruta).
esPeligrosa(fruta(paramecia, opeope)).
esPeligrosa(fruta(logia, _, _)).
esPeligrosa(fruta(zoan, _, Especie)):-
  esFeroz(Especie).

% esFeroz(Transformacion).
esFeroz(lobo).
esFeroz(leopardo).
esFeroz(anaconda).

%% Punto 6 b)
/*
La elección de los parametros (copiar el functor) del functor se debe a que creí conveniente abstraer esPeligrosa, de manera que el enunciado pueda clasificar si son o no peligrosas todos los tipos de fruta independientemente de su forma, es por ello que es un enunciado polimorfico.  
Por otro lado, por universo cerrado, no es necesario que el predicado esPeligrosa sea inversible ya que, unicamente, se conoce el valor de verdad de las frutas que fueron comidas por las personas mencionadas, no se pueden generar frutas nuevas. Sin embargo, el predicado comio y esPeligroso deben ser inversibles ya que se podria consultar informacion de los piratas en relaciona sus ingestas.
*/

%% Punto 7
% puedeNadar(Pirata).
puedeNadar(Pirata):-
  tripulante(Pirata, _),   
  not(comio(Pirata,_)).

% piratasDeAsfalto(Tripulacion).
piratasDeAsfalto(Tripulacion):-
  tripulante(_,Tripulacion),
  forall(tripulante(Pirata, Tripulacion), not(puedeNadar(Pirata))).