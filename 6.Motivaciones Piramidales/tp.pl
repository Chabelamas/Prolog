%% Punto 1
% necesidad(Necesidad, Nivel).
necesidad(respiracion, fisiologico).
necesidad(alimentacion, fisiologico).
necesidad(descanso, fisiologico).
necesidad(reproduccion, fisiologico).
necesidad(integridadFisica, seguridad).
necesidad(empleo, seguridad).
necesidad(salud, seguridad).
necesidad(confianza, reconocimiento).
necesidad(respeto, reconocimiento).
necesidad(exito, reconocimiento).
necesidad(amistad, social).
necesidad(afecto, social).
necesidad(intimidad, social).
necesidad(tituloUniversitario,autorrealizacion).
necesidad(lucianoPereyra, autorrealizacion).
necesidad(bandera, autorrealizacion).


% nivelSuperior(Superior, Inferior).
nivelSuperior(autorrealizacion, reconocimiento).
nivelSuperior(reconocimiento, social).
nivelSuperior(social, seguridad).
nivelSuperior(seguridad, fisiologico).


%% Punto 2
% separacionNiveles(Necesidad1, Necesidad2, Separacion).
separacionNiveles(Necesidad1, Necesidad2, Separacion):-
    posicionNecesidad(Necesidad1, Posicion1),
    posicionNecesidad(Necesidad2, Posicion2),
    Separacion is abs(Posicion1-Posicion2).

% posicionNecesidad(Necesidad, Posicion).
posicionNecesidad(Necesidad, Posicion):-
    necesidad(Necesidad, Nivel),
    posicion(Nivel,Posicion).

% posicion(Nivel, Posicion).
posicion(Nivel,1):-
    necesidad(_,Nivel),
    not(nivelSuperior(Nivel,_)).   

posicion(Nivel,Posicion):-
    necesidad(_,Nivel),
    nivelSuperior(Nivel,_),
    nivelSuperior(Nivel,NivelInf),
    posicion(NivelInf,PosNivel),
    Posicion is PosNivel + 1.


%% Punto 3
% sinSatisfacer(Persona, Necesidad).
sinSatisfacer(carla, alimentacion).
sinSatisfacer(carla, descanso).
sinSatisfacer(carla, empleo).
sinSatisfacer(juan, afecto).
sinSatisfacer(juan, exito).
sinSatisfacer(roberto, amistad).
sinSatisfacer(manuel, bandera).
sinSatisfacer(charly, afecto).


%% Punto 4
% necesidadMayorJerarquia(Persona, NecesidadMayorJerarquia).
necesidadMayorJerarquia(Persona, Necesidad):-
    sinSatisfacer(Persona, Necesidad),
    posicionNecesidad(Necesidad, Posicion),
    not((sinSatisfacer(Persona, NecesidadOtra), posicionNecesidad(NecesidadOtra, PosicionOtra), PosicionOtra > Posicion)).


%% Punto 5
% satisfaceNivel(Persona, NivelSatisfecho).
satisfaceNivel(Persona, Nivel):-
    sinSatisfacer(Persona, _),
    necesidad(_, Nivel),
    forall(necesidad(Necesidad, Nivel), not(sinSatisfacer(Persona, Necesidad))).
    

%% Punto 6 
/*
Motivación
La teoría de Maslow plantea que la motivación de cualquier persona para actuar parte de sus necesidades y a medida que se satisfacen las necesidades más básicas se manifiestan otras, lo que hace que sus motivaciones también sean diferentes. En base a eso, uno de sus elementos centrales de es que las personas sólo atienden necesidades superiores cuando han satisfecho las necesidades inferiores. Por ejemplo, las necesidades de seguridad surgen cuando las necesidades fisiológicas están satisfechas. 


Definir los predicados que permitan analizar si es cierta o no la teoría de Maslow:
Para una persona en particular.
Para todas las personas.
Para la mayoría de las personas. 

Nota: existen los predicados de aridad 0. Por ejemplo: 
noLlegoElFinDelMundo :- vive(Alguien)..*/

falsaTeoriaDeMaslow :-
    satisfaceNivel(Persona, Nivel),
    posicion(Nivel,Posicion),
    PosicionAnterior is Posicion - 1,
    not((posicion(NivelAnterior,PosicionAnterior),satisfaceNivel(Persona, NivelAnterior))).                    





