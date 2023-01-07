:- module(строки, [с_заглавной_буквы/2]).

с_заглавной_буквы(In, Out):-
    sub_string(In, 0, 1, After, First),
    sub_string(In, 1, After, _, Others),
    string_upper(First, FirstUpper),
    concat(FirstUpper, Others, Out).

