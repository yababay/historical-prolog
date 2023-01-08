:- module(redis_db, [имя_по_ид/2, сын_родителя/2]).

имя_по_ид(UUID, Name):-
    atom_concat("", "common_name", common_name),
    свойство_по_ид(UUID, common_name, Out).

титул_по_ид(UUID, Name):-
    atom_concat("", "title", title),
    свойство_по_ид(UUID, title, Out).

свойство_по_ид(UUID, Prop, Out):-
    redis_server(default, redis:6379, []),
    atom_concat("person:", UUID, Key),
    redis(default, hget(Key, Prop), Out).

родственники(UUID_1, UUID_2, Fact):-
    redis_server(default, redis:6379, []),
    имя_по_ид(UUID_1, First),
    atom_concat("father_of:",   UUID_1, FatherKey),
    atom_concat("mather_of:",   UUID_1, MatherKey),
    atom_concat("husband_of:",  UUID_1, HusbandKey),
    atom_concat("wife_of:",     UUID_1, WifeKey),
    atom_concat("son_of:",      UUID_1, SonKey),
    atom_concat("doughter_of:", UUID_1, DoughterKey),
    atom_concat("", UUID_2, Second),
    (
        redis(default, get(FatherKey), 
        FromDb), FromDb == Second,
        format(atom(Fact), '', []);

