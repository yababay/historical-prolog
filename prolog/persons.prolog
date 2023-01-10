:- module(redis_db, [
	имя_по_ид/2, 
	титул_по_ид/2, 
	имя_в_родительном_по_ид/2, 
	пол_по_ид/2, 
	гиперссылка_по_ид/2,
	родитель_ребенка/3,
	ребенок_родителя/3,
	приходится_супругом/3,
	кем_приходится/3
]).

супруг(1, 'муж').
супруг(0, 'жена').
родитель(1, 'отец').
родитель(0, 'мать').
ребенок(1, 'сын').
ребенок(0, 'дочь').

гиперссылка_по_ид(UUID, Out):-
    свойство_личности_по_ид(UUID, "link", Out).

имя_по_ид(UUID, Out):-
    свойство_личности_по_ид(UUID, "common_name", Out).

имя_в_родительном_по_ид(UUID, Out):-
    свойство_личности_по_ид(UUID, "genitive", Out).

титул_по_ид(UUID, Out):-
    свойство_личности_по_ид(UUID, "title", Out).

пол_по_ид(UUID, Out):-
    свойство_личности_по_ид(UUID, "gender", Out).

родитель_ребенка(UUID_1, UUID_2, Gender):-
    родство_и_пол(UUID_1, UUID_2, "parent_of:", Gender).

ребенок_родителя(UUID_1, UUID_2, Gender):-
    родство_и_пол(UUID_1, UUID_2, "child_of:", Gender).

приходится_супругом(UUID_1, UUID_2, Gender):-
    родство_и_пол(UUID_1, UUID_2, "spouse_of:", Gender).

кем_приходится(UUID_1, UUID_2, Родство):-
    ребенок_родителя(UUID_1, UUID_2, Пол), ребенок(Пол, Родство),!;
    родитель_ребенка(UUID_1, UUID_2, Пол), родитель(Пол, Родство),!;
    приходится_супругом(UUID_1, UUID_2, Пол), супруг(Пол, Родство),!.

родство_и_пол(UUID_1, UUID_2, Rel, Gender):-
    atom_concat(Rel, UUID_1, RelKey),
    atom_concat("", UUID_2, UUID_3),
    redis_server(default, redis:6379, []),
    redis(default, get(RelKey), UUID_4),
    UUID_3 == UUID_4,
    пол_по_ид(UUID_1, Gender).

свойство_личности_по_ид(UUID, PropStr, Out):-
    atom_concat("", PropStr, Prop),
    atom_concat("person:", UUID, Key),
    redis_server(default, redis:6379, []),
    redis(default, hget(Key, Prop), Out).

:- begin_tests(persons).

test(кем_приходится):-
    кем_приходится("1a59c12b-2f8c-4e9d-8fe4-290695db11db", "5a9d8df0-3124-48a3-ae4b-b173d5bde221", Родство),
    assertion(Родство == 'сын').

test(имя_по_ид) :-
	имя_по_ид("96425b4e-937c-407d-b01d-058a310a5bcd", Свойство),
        assertion(Свойство == 'Ольга').

test(имя_в_родительном_по_ид) :-
	имя_в_родительном_по_ид("96425b4e-937c-407d-b01d-058a310a5bcd", Свойство),
        assertion(Свойство == 'Ольги').

test(титул_по_ид) :-
	титул_по_ид("96425b4e-937c-407d-b01d-058a310a5bcd", Свойство),
        assertion(Свойство == 'княгиня киевская').

test(пол_по_ид) :-
	пол_по_ид("96425b4e-937c-407d-b01d-058a310a5bcd", Свойство),
        assertion(Свойство == 0).

test(гиперссылка_по_ид) :-
	гиперссылка_по_ид("96425b4e-937c-407d-b01d-058a310a5bcd", Свойство),
	sub_string(Свойство, 0, 5, _, Sub),
	atom_concat("", Sub, Https),
        assertion(Https == 'https').

test(ребенок_родителя):-
	ребенок_родителя("1a59c12b-2f8c-4e9d-8fe4-290695db11db", "5a9d8df0-3124-48a3-ae4b-b173d5bde221", Пол),
	assertion(Пол == 1).

test(родитель_ребенка):-
	родитель_ребенка("5a9d8df0-3124-48a3-ae4b-b173d5bde221", "1a59c12b-2f8c-4e9d-8fe4-290695db11db", Пол),
	assertion(Пол == 1).

test(ребенок_родителя):-
	ребенок_родителя("8be48fa1-dce8-487d-94d2-a4d0b3c8160c", "96425b4e-937c-407d-b01d-058a310a5bcd", Пол),
	assertion(Пол == 1).

test(родитель_ребенка):-
	родитель_ребенка("96425b4e-937c-407d-b01d-058a310a5bcd", "8be48fa1-dce8-487d-94d2-a4d0b3c8160c", Пол),
	assertion(Пол == 0).

tect(приходится_супругом):-
	приходится_супругом("1a59c12b-2f8c-4e9d-8fe4-290695db11db", "96425b4e-937c-407d-b01d-058a310a5bcd", Пол),
	assertion(Пол == 0).

tect(приходится_супругом):-
	приходится_супругом("96425b4e-937c-407d-b01d-058a310a5bcd", "1a59c12b-2f8c-4e9d-8fe4-290695db11db", Пол),
	assertion(Пол == 1).

:- end_tests(persons).

