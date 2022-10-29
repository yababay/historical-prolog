:- module(кубок_из_черепа_пир, [
	факт_о_пире/2
]).

:- use_module("persons").
:- use_module("sources").
:- use_module("ethnic-groups").
:- use_module("facts").
:- use_module("grammatics").
:- use_module("collision").

/*
а_был_ли_пир(Н, А, Ф):-
    пил_на_пиру_с_женой_из_такого_кубка(М, И),
    not(источник(А, И)),
    format(atom(Ф), "О супругах, пивших из такого кубка, ~w не сообщает.", [А]),!.

а_был_ли_пир(Н, А1, Ф):-
    пил_на_пиру_с_женой_из_такого_кубка(Н, И),
    источник(А2, И),
    А1 == А2,
    факт_о_пире(Н, Ф).
*/

факт_о_жене(Ж, Ф):-
    Ж == null, format(atom(Ф), "свою жену", []),!.

факт_о_жене(Ж, Ф):-
    Ж \= null, 
    винительный_падеж(ЖТП, Ж),
    format(atom(Ф), "свою жену ~w", [ЖТП]),!.

факт_о_пире(Н, Ф):- 
    родительный_падеж(НРП, Н),
    лидер(М, _, НРП),
    пил_на_пиру_с_женой_из_такого_кубка(М, _),
    историческая_личность(М, ИД1),
    жена(ИД2, ИД1),
    историческая_личность(Ж, ИД2),
    факт_о_жене(Ж, ФЖ),
    format(atom(Ф), "На пиру он не только сам пил из этого кубка, но и призывал делать это ~w.", [ФЖ]).

