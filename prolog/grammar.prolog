:- module(работа_со_словами, [
	с_заглавной_буквы/2,
	в_родительном/2,
	в_дательном/2,
	в_винительном/2,
	в_творительном/2,
	в_предложном/2
]).

с_заглавной_буквы(In, Out):-
    sub_string(In, 0, 1, After, First),
    sub_string(In, 1, After, _, Others),
    string_upper(First, FirstUpper),
    concat(FirstUpper, Others, Out).

в_падеже(Слово, Падеж, ВПадеже):-
    atom_concat(Падеж, ':', Префикс),
    atom_concat(Префикс, Слово, Ключ),
    redis_server(default, redis:6379, []),
    redis(default, get(Ключ), ВПадеже).

в_родительном(Слово, ВПадеже):-
    в_падеже(Слово, "родительный", ВПадеже).

в_дательном(Слово, ВПадеже):-
    в_падеже(Слово, "дательный", ВПадеже).

в_винительном(Слово, ВПадеже):-
    в_падеже(Слово, "винительный", ВПадеже).

в_творительном(Слово, ВПадеже):-
    в_падеже(Слово, "творительный", ВПадеже).

в_предложном(Слово, ВПадеже):-
    в_падеже(Слово, "предложный", ВПадеже).

:- begin_tests(grammar).

test(в_родительном):-
	в_родительном("отец", ВПадеже),
	assertion(ВПадеже == 'отца').

test(в_дательном):-
	в_дательном("отец", ВПадеже),
	assertion(ВПадеже == 'отцу').

test(в_винительном):-
	в_винительном("отец", ВПадеже),
	assertion(ВПадеже == 'отца').

test(в_творительном):-
	в_творительном("отец", ВПадеже),
	assertion(ВПадеже == 'отцом').

test(в_предложном):-
	в_предложном("отец", ВПадеже),
	assertion(ВПадеже == 'отце').

test(с_заглавной_буквы):-
	с_заглавной_буквы("князь", СЗаглавной),
	assertion(СЗаглавной == 'Князь').

:- end_tests(grammar).


