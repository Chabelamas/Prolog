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
verdaderaTeoriaDeMaslow:-
    not((satisfaceNivel(Persona,_), not(verdaderaTeoriaDeMaslowParaUnaPersona(Persona)))). 

verdaderaTeoriaDeMaslowParaUnaPersona(Persona):-
    sinSatisfacer(Persona,_),
    posicion(Nivel,Posicion),
    not(satisfaceNivel(Persona, Nivel)),
    forall(satisfaceNivel(Persona, NivelA), (posicion(NivelA,PosicionAnterior), Posicion > PosicionAnterior)).

verdaderaTeoriaDeMaslowMayoria:-
    cantidadPersonas(CantPersonas),
    cantidadPersonasVerdadera(CantPersonasVerdadera),
    MitadPoblacion is CantPersonas/2,
    CantPersonasVerdadera >= MitadPoblacion.

cantidadPersonas(CantPersonas):-
    findall(Persona, sinSatisfacer(Persona, _), Personas),
    list_to_set(Personas, PersonasSinRepe),
    length(PersonasSinRepe, CantPersonas).

cantidadPersonasVerdadera(CantPersonas):-
    findall(Persona, verdaderaTeoriaDeMaslowParaUnaPersona(Persona), Personas),
    list_to_set(Personas, PersonasSinRepe),
    length(PersonasSinRepe, CantPersonas).


/*-------    otra variante    ---------  */
falsateoriaDeMaslowParaUnaPersona(Persona):-
    satisfaceNivel(Persona, Nivel),
    posicion(Nivel,Posicion),
    posicion(OtroNivel,PosicionAnterior),
    PosicionAnterior < Posicion,
    not(satisfaceNivel(Persona, OtroNivel)). 

falsaTeoriaDeMaslow:-
    falsateoriaDeMaslowParaUnaPersona(_).

falsaTeoriaDeMaslowMayoria:-
    cantidadPersonas(CantPersonas),
    cantidadPersonasFalsa(CantPersonasFalsa),
    MitadPoblacion is CantPersonas/2,
    CantPersonasFalsa >= MitadPoblacion.     

cantidadPersonasFalsa(CantPersonas):-
    findall(Persona, falsateoriaDeMaslowParaUnaPersona(Persona), Personas),
    list_to_set(Personas, PersonasSinRepe),
    length(PersonasSinRepe, CantPersonas).


%% Punto 7
/*
 > Frase elegida:
"Porque tuve hambre, y ustedes me dieron de comer; tuve sed, y me dieron de beber; 
fui forastero, y me dieron alojamiento; necesité ropa, y me vistieron; estuve enfermo, y me atendieron; 
estuve en la cárcel, y me visitaron." Jesús de Nazareth (Mateo 25; 35-36)
*/

% obrasCaridad(Persona, ayudoA(AccionParaAyudar, Atendido)).
% obrasCaridad(Persona, necesidades(ListaNecesidades)).
obrasCaridad(alan, ayudoA(dioComida, jesus)).
obrasCaridad(mica, ayudoA(dioBebida, jesus)).
obrasCaridad(gabi, ayudoA(dioHogar, jesus)).
obrasCaridad(flor, ayudoA(dioRopa, jesus)).
obrasCaridad(joselin, ayudoA(atendio, jesus)).
obrasCaridad(chabela, ayudoA(vioEnCarcel, jesus)).
obrasCaridad(jesus, necesidades([comer, tomar, alojarse, vestirse, serAtendido, serVisitadoEnCarcel])).

% satisface(AccionParaAyudar, NecesidadQueSatisface).
satisface(dioComida, comer).
satisface(dioBebida, tomar).
satisface(dioHogar, alojarse).
satisface(dioRopa, vestirse).
satisface(atendio, serAtendido).
satisface(vioEnCarcel, serVisitadoEnCarcel).


% estaVivo(Persona).
estaVivo(Persona):- 
    obrasCaridad(Persona, Accion),
    cumplenCriterioDeVivir(Persona, Accion).

% cumplenCriterioDeVivir(Persona, Accion).
cumplenCriterioDeVivir(Persona, necesidades(ListaNecesidades)):-
    forall(member(Necesidad, ListaNecesidades), (obrasCaridad(_, ayudoA(Ayuda, Persona)), satisface(Ayuda, Necesidad))).
cumplenCriterioDeVivir(_, ayudoA(_, _)).

/*
El predicado 'estaVivo' resulta ser polimórfico, ya que al contar con predicados auxiliares que puedan recibir diferentes alternativas, no debe ser modificado ni reescrito varias veces. Además, es posible agregarle cláusulas nuevas o nueva formas de 'estarVivo' sin que se vea afectado por ello el predicado original.
*/