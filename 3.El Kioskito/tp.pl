

% atiende(Nombre, Dia, horario(Comienzo, Fin)).
atiende(dodain, lunes, horario(9, 15)). 
atiende(dodain, miercoles, horario(9, 15)). 
atiende(dodain, viernes, horario(9, 15)). 
atiende(lucas, martes, horario(10, 20)).
atiende(juanC, sabado, horario(18, 22)).
atiende(juanC, domingo, horario(18, 22)).
atiende(juanFdS, jueves, horario(10, 20)).
atiende(juanFdS, viernes, horario(12, 20)).
atiende(leoC,lunes, horario(14, 18)).
atiende(leoC,miercoles, horario(14, 18)).
atiende(martu,miercoles, horario(23, 24)).


%% Punto 1
atiende(vale, Dia, Horas):-
  atiende(dodain, Dia, Horas).
atiende(vale, Dia, Horas):-
  atiende(juanC, Dia, Horas).

/*
LeoC no es añadido a la base de conocimientos debido al principio de universo cerrado, solamente se describen hechos en la base de conocimiento.
Maiu al pensando en hacer los nuevos turnos, no se deben poner en la base de conocimiento. Esto ocurre gracias al  principio de universo cerrado, donde lo desconocido se presume falso.
*/

%% Punto 2
% quienesAtienden(Persona, Dia, Hora).
quienesAtienden(Persona, Dia, Hora):-
  atiende(Persona, Dia, horario(Comienzo, Fin)),
  between(Comienzo, Fin, Hora).


%% Punto 3
% foreverAlone(Persona, Dia, Hora)
foreverAlone(Persona, Dia, Hora):-
  quienesAtienden(Persona, Dia, Hora),
  atiende(OtraPersona, _, _), 
  not((quienesAtienden(OtraPersona, Dia, Hora), Persona \= OtraPersona)).

%% Punto 4
/*
Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día. Por ejemplo, si preguntamos por el miércoles, tiene que darnos esta combinatoria:
nadie
dodain solo
dodain y leoC
dodain, vale, martu y leoC
vale y martu
etc.

Queremos saber todas las posibilidades de atención de ese día. La única restricción es que la persona atienda ese día (no puede aparecer lucas, por ejemplo, porque no atiende el miércoles).

Punto extra: indique qué conceptos en conjunto permiten resolver este requerimiento, justificando su respuesta.
*/
