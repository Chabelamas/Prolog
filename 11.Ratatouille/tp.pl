%% BASE DE DATOS
% rata(Nombre, DondeVive).
rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).

% cocina(Cocinero, Plato, NivelDeExperiencia).
cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).

% trabajaEn(LugarDeTrabajo, Empleado).
trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

% plato(Plato, entrada(Ingredientes)).
% plato(Plato, principal(Guarnicion, MinutosDeCoccion)).
% plato(Plato, postre(Calorias)).
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).

% grupo(Nombre).
grupo(frutillasConCrema).


%% PUNTO 1
% inspeccionSatisfactoria(Restaurante).
inspeccionSatisfactoria(Restaurante):-
    trabajaEn(Restaurante, _),
    not(rata(_, Restaurante)).


%% PUNTO 2
% chef(Empleado, Restaurante).
chef(Empleado, Restaurante):-
    trabajaEn(Restaurante, Empleado),
    cocina(Empleado, _, _).

%% PUNTO 3
% chefcito(Rata).
chefcito(Rata):-
    rata(Rata, Restaurante),
    trabajaEn(Restaurante, linguini).


%% PUNTO 4 
% cocinaBien(Empleado, Plato).
cocinaBien(Empleado, Plato):-
    cocina(Empleado, Plato, Experiencia),
    Experiencia > 7.

cocinaBien(remy, Plato):-
    cocina(_, Plato, _).


%% PUNTO 5
% encargadoDe(Empleado, Plato, Restaurante).
encargadoDe(Empleado, Plato, Restaurante):-
    trabajaEn(Restaurante, Empleado),
    cocina(Empleado, Plato, Experiencia),
    forall((trabajaEn(Restaurante, Empleado2), Empleado2 \= Empleado, cocina(Plato, Empleado2, Experiencia2)), Experiencia2 < Experiencia).


%% PUNTO 6
% saludable(Plato)
saludable(Plato):-
    plato(Plato, postre(_)),
    grupo(Plato).

saludable(Plato):-
    plato(Plato, Tipo),
    calcularCalorias(Plato, Tipo, Calorias),
    Calorias < 75.

% calcularCalorias(Plato, Tipo, Calorias).
calcularCalorias(_, entrada(Ingredientes), Calorias):-
    length(Ingredientes, CantIngredientes),
    Calorias is CantIngredientes * 15.

calcularCalorias(Plato, postre(Calorias), Calorias):-
    not(grupo(Plato)).

calcularCalorias(_, principal(Guarnicion, MinutosDeCoccion), Calorias):-
    aporteGuarnicion(Guarnicion, CaloriasAportadas),
    Calorias is MinutosDeCoccion * 5 + CaloriasAportadas.

% aporteGuarnicion(Guarnicion, Calorias).
aporteGuarnicion(papasFritas, 50).
aporteGuarnicion(pure, 20).
aporteGuarnicion(ensalada, 0).


%% PUNTO 7
% criticaPositiva(Critico, Restaurante).
criticaPositiva(Critico, Restaurante):-
    inspeccionSatisfactoria(Restaurante),
    platoCocinadoEn(Restaurante, _),
    cumpleCriterios(Critico, Restaurante).

% cumpleCriterios(Critico, Restaurante).
cumpleCriterios(antonEgo, Restaurante):-
    especialista(ratatouille, Restaurante).

cumpleCriterios(christophe, Restaurante):-
    findall(Empleado, chef(Empleado, Restaurante), Empleados),
    length(Empleados, CantEmpleados),
    CantEmpleados > 3.

cumpleCriterios(cormillot, Restaurante):-
    forall(platoCocinadoEn(Restaurante, Plato), saludable(Plato)),
    todasLasEntradasTienen(zanahoria, Restaurante).

% especialista(Plato, Restaurante).
especialista(Plato, Restaurante):-
    not((chef(Empleado, Restaurante), not(cocinaBien(Empleado, Plato)))).

% platoCocinadoEn(Restaurante, Plato).
platoCocinadoEn(Restaurante, Plato):-
    chef(Empleado, Restaurante), 
    cocina(Empleado, Plato, _).

% todasLasEntradasTienen(Ingrediente, Restaurante). 
todasLasEntradasTienen(Ingrediente, Restaurante):-
    forall((platoCocinadoEn(Restaurante, Plato), plato(Plato, entrada(Ingredientes))), member(Ingrediente, Ingredientes)).