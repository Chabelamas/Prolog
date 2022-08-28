%%% Parte 1 - Sombrero Seleccionador
% caracter(Nombre, Caracter).
caracter(harry, [coraje, amistoso, orgullo, inteligencia]).
caracter(draco, [inteligencia, orgullo]).
caracter(hermione, [inteligencia, orgullo, responsabilidad]).

% sangre(Nombre, Status).
sangre(harry, mestizo).
sangre(draco, puro).
sangre(hermione, impura).

% evitaCasa(Nombre, Casa).
evitaCasa(harry, slytherin).
evitaCasa(draco, hufflepuff).

% priorizaCaract(Casa, Caracteristica).
priorizaCaract(gryffindor, [coraje]).
priorizaCaract(slytherin, [orgullo, inteligencia]).
priorizaCaract(ravenclaw, [inteligencia, responsabilidad]).
priorizaCaract(hufflepuff, [amistoso]).


%% Punto 1
% esMagoYCasa(Mago, Casa).
esMagoYCasa(Mago, Casa):-
    sangre(Mago,_),
    priorizaCaract(Casa, _).

% permiteEntrar(Mago, Casa).
permiteEntrar(Mago, slytherin):-
    sangre(Mago,_),
    not(sangre(Mago,impura)).

permiteEntrar(Mago, Casa):-
    esMagoYCasa(Mago, Casa),
    Casa \= slytherin.


%% Punto 2
% caracterApropiado(Mago, Casa).
caracterApropiado(Mago, Casa):-
    esMagoYCasa(Mago, Casa),
    forall((priorizaCaract(Casa, Lista), member(Caracter, Lista)), (caracter(Mago, ListaMago), member(Caracter, ListaMago))).
    %not((priorizaCaract(Casa, Lista), member(Caracter, Lista), caracter(Mago, ListaMago), not(member(Caracter, ListaMago)))).


%% Punto 3
% puedeSerSeleccionado(Mago, Casa).
puedeSerSeleccionado(Mago, Casa):-
    esMagoYCasa(Mago, Casa),
    caracterApropiado(Mago, Casa),
    permiteEntrar(Mago, Casa),
    not(evitaCasa(Mago, Casa)).

puedeSerSeleccionado(hermione, gryffindor).


%% Punto 4
%esAmistoso(Mago).
esAmistoso(Mago):-
    sangre(Mago,_),
    caracter(Mago, ListaCaracter),
    member(amistoso, ListaCaracter).

%cadenaDeAmistades(Lista).
cadenaDeAmistades([]).

cadenaDeAmistades([Mago]):-
    sangre(Mago,_).

cadenaDeAmistades([Mago,MagoSig|Cola]):-
    esAmistoso(Mago),
    permiteEntrar(MagoSig, Casa),
    permiteEntrar(Mago, Casa),
    cadenaDeAmistades([MagoSig|Cola]).

%%% Parte 2 - La copa de las casas
% esDe(Mago, Casa).
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% hizo(Mago, Accion).
hizo(harry, andarFueraDeCama).
hizo(harry, visito(bosque)).
hizo(harry, visito(tercerPiso)).
hizo(hermione, visito(tercerPiso)).
hizo(hermione, visito(seccionProhibidaBibloteca)).
hizo(draco, visito(mazmorras)).
hizo(ron, ganarAjedrez).
hizo(hermione, salvarAmigos).
hizo(harry, ganarVoldemort).
hizo(hermione, responde(donde_se_encuentra_un_bezoar, 20, snape)).
hizo(hermione, responde(como_hacer_levitar_una_pluma, 25, flitwick)).

% lugarProhibido(Lugar, PuntosARestar).
lugarProhibido(bosque, -50).
lugarProhibido(seccionProhibidaBibloteca, -10).
lugarProhibido(tercerPiso, -75).

% puntajeAccion(Accion, Puntaje).
puntajeAccion(salvarAmigos, 50).
puntajeAccion(ganarAjedrez, 50).
puntajeAccion(ganarVoldemort, 60).
puntajeAccion(andarFueraDeCama, -50).
puntajeAccion(visito(Lugar), Puntaje):-
    lugarProhibido(Lugar, Puntaje).
puntajeAccion(responde(Pregunta, Dificultad, snape), Puntaje):-
    hizo(_, responde(Pregunta, Dificultad, snape)),
    Puntaje is Dificultad/2.
puntajeAccion(responde(Pregunta, Dificultad, Profesor), Dificultad):-
    hizo(_, responde(Pregunta, Dificultad, Profesor)),
    Profesor \= snape.

%% Punto 1
% malaAccion(Accion).
malaAccion(Accion):-
    puntajeAccion(Accion, Puntaje), 
    Puntaje < 0.

%buenAlumno(Mago).
buenAlumno(Mago):-
    esDe(Mago, _),
    not((hizo(Mago, Accion), malaAccion(Accion))).

% accionRecurrente(Accion).
accionRecurrente(Accion):-
    hizo(Mago1, Accion),
    hizo(Mago2, Accion),
    Mago1 \= Mago2.


%% Punto 2
% puntajeTotal(Casa, PuntajeTotal).
puntajeTotal(Casa, PuntajeTotal):-
    esDe(_, Casa),
    valoresAccionesCasa(Casa, ListaPuntos),
    sum_list(ListaPuntos, PuntajeTotal).

% valoresAccionesCasa(Casa, ListaPuntos)
valoresAccionesCasa(Casa, ListaPuntos):-
    findall(Puntaje, (esDe(Mago, Casa), hizo(Mago, Accion), puntajeAccion(Accion, Puntaje)), ListaPuntos).


%% Punto 3
ganadorDeCopa(Casa):-
    puntajeTotal(Casa, PuntajeTotal),
    not((puntajeTotal(Casa2, PuntajeTotal2), Casa2 \= Casa, PuntajeTotal2 > PuntajeTotal)).


%% Punto 4 
% hizo(Mago, responde(QuePregunta, Difucultad, QuienLaHizo)).

% puntajeAccion(responde(QuePregunta, Difucultad, QuienLaHizo), Puntaje).