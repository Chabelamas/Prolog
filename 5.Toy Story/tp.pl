% Relaciona al dueno con el nombre del juguete y la cantidad de anios que lo ha tenido
dueno(andy, woody, 8).
dueno(sam, jessie, 3).
dueno(andy, buzz, 8). % lo sume yo por el punto 4
% Forma de los juguetes
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(senorCaraDePapa, caraDePapa([original(pieIzquierdo), original(pieDerecho), repuesto(nariz)])).

% Dice si un juguete es raro
% esRaro(Forma)
esRaro(deAccion(stacyMalibu, [sombrero])). 
% Dice si una persona es coleccionista
esColeccionista(sam).

%% Punto 1
tematica(Juguete,caraDePapa):-
    juguete(Juguete, caraDePapa(_)).
tematica(Juguete, Tematica):-
    juguete(Juguete, Forma),
    obtenerTematica(Forma, Tematica).

obtenerTematica(deTrapo(Tematica),Tematica).
obtenerTematica(deAccion(Tematica, _),Tematica).
obtenerTematica(miniFiguritas(Tematica, _),Tematica).

esDePlastico(Juguete):- 
    juguete(Juguete, caraDePapa(_)).

esDePlastico(Juguete):- 
    juguete(Juguete, miniFiguras(_)).

/*
PREGUNTAR SI ES MEJOR
esDePlastico(Juguete) :-
    juguete(Juguete, Forma),
    esMiniFiguraOCaraDePapa(Forma).

esMiniFiguraOCaraDePapa(miniFiguras(_, _)).
esMiniFiguraOCaraDePapa(caraDePapa(_)).
*/

esDeColeccion(Juguete) :- juguete(Juguete,deTrapo(_)).
esDeColeccion(Juguete) :- 
    juguete(Juguete,Forma), 
    esCaraPapaOAccion(Forma), 
    esRaro(Forma).

esCaraPapaOAccion(caraDePapa(_,_)).
esCaraPapaOAccion(deAccion(_)).

        
%% Punto 2
amigoFiel(Dueno, Juguete):-
    dueno(Dueno, Juguete, _),
    not(esDePlastico(Juguete)),
    esMasViejoDePlastico(Dueno, Juguete). 

esMasViejoDePlastico(Dueno, Juguete) :-
    dueno(Dueno, Juguete, Edad),
    not((dueno(Dueno, OtroJuguete, OtraEdad), not(esDePlastico(OtroJuguete)), OtraEdad > Edad)).


%% Punto 3
superValioso(Juguete):-
    dueno(Dueno, Juguete, _),
    not(esColeccionista(Dueno)),
    esOriginal(Juguete).

esOriginal(Juguete):-
    juguete(Juguete,Forma),
    objetosOriginales(Forma).

objetosOriginales(deAccion(_, Lista)):-
    forall(member(Lista, Elemento), Elemento is original(_)).

objetosOriginales(caraDePapa(Lista)):-
    not((member(repuesto(_), Lista))).


%% Punto 4 
duoDinamico(Dueno, Juguete1, Juguete2):-
    dueno(Dueno, Juguete1, _),
    dueno(Dueno, Juguete2, _),
    Juguete1 \= Juguete2,
    hacenBuenaPareja(Juguete1, Juguete2).

hacenBuenaPareja(woody, buzz).
hacenBuenaPareja(Juguete1, Juguete2):-
    juguete(Juguete1,Forma1),
    juguete(Juguete2,Forma2),
    obtenerTematica(Forma1, Tematica),
    obtenerTematica(Forma2, Tematica).


%% Punto 5 
felicidad(Dueno, FelicidadTotal):-
    dueno(Dueno, _, _),
    listaJuguetesPropios(Dueno, ListaJuguetes),
    obtenerFelicidadTotal(ListaJuguetes, FelicidadTotal).

listaJuguetesPropios(Dueno, ListaJuguetes):-
    findall(Juguete, dueno(Dueno, Juguete, _), ListaJuguetes).

obtenerFelicidadTotal(ListaJuguetes, FelicidadTotal):-
    findall(Felicidad, (member(Juguete, ListaJuguetes), calculoFelicidad(Juguete, Felicidad)), Felicidades),
    sum_list(Felicidades,FelicidadTotal).

calculoFelicidad(Juguete, Felicidad):-
    juguete(Juguete,miniFiguras(_, CantidadDeFiguras)),
    Felicidad is 20 * CantidadDeFiguras.

calculoFelicidad(Juguete, 100):-
    juguete(Juguete,deTrapo(_)).

calculoFelicidad(Juguete, 120):-
    juguete(Juguete,deAccion(_, _)),
    esDeColeccion(Juguete),
    dueno(Dueno, Juguete, _),
    esColeccionista(Dueno).
    
calculoFelicidad(Juguete, 100):-
    juguete(Juguete,deAccion(_, _)).

calculoFelicidad(Juguete, FelicidadTotal):-
    juguete(Juguete,caraDePapa(Lista)),
    findall(Felicidad, (member(Pieza, Lista), obtenerPuntoPieza(Pieza, Felicidad)), Felicidades),
    sum_list(Felicidades, FelicidadTotal).

obtenerPuntoPieza(original(_), 5).
obtenerPuntoPieza(repuesto(_), 8).


%% Punto 6
puedeJugarCon(Persona, Juguete):-
    dueno(Persona, Juguete, _).

puedeJugarCon(Persona, Juguete):-
    dueno(Dueno, Juguete, _),
    puedePrestarJuguete(Persona, Dueno).

puedePrestarJuguete(Persona, Dueno):-
    cantidadDeJuguetes(Persona, CantidadDeJuguetesPersona),
    cantidadDeJuguetes(Dueno, CantidadDeJuguetesDueno),
    CantidadDeJuguetesPersona > CantidadDeJuguetesDueno.

cantidadDeJuguetes(Dueno, CantidadDeJuguetes):-
    listaJuguetesPropios(Dueno, ListaJuguetes),
    sum_list(ListaJuguetes, CantidadDeJuguetes).


%% Punto 7
podriaDonar(Dueno, ListaJuguetes, CantFelicidadLimite):-
    dueno(Dueno, _, _),
    obtenerFelicidadTotal(ListaJuguetes, FelicidadTotal),
    CantFelicidadLimite > FelicidadTotal.


%% Punto 8
/*
 > Comentar dónde se aprovechó el polimorfismo.
El polimorfismo se puede aprovechar a lo largo de varios predicados que hacen uso de las formas de los juguetes (juguete(NommbreJuguete, Forma)), como asi tambien de las piezas que estos contenian. Por ejemplo en el punto 1, en obtenerTematica(Forma,Tematica), se pudo utilizar este concepto ya que se otorgaban las tematicas a partir de como era el juguete (deTrapo, miniFiguras, deAccion caraDePapa). Otros casos donde se utiliza este termino son en los siguientes predicados: obtenerPuntoPieza(Pieza, Felicidad), esCaraPapaOAccion(Forma) y objetosOriginales(Forma).
*/