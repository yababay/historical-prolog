:- module(redis_db, [имя_по_ид/2, сын_родителя/2]).

имя_по_ид(UUID, Name):-
    redis_server(default, redis:6379, []),
    atom_concat("person:", UUID, Key),
    redis(default, hget(Key, common_name), Name).

сын_родителя(SonUUID, ParentUUID):-
    redis_server(default, redis:6379, []),
    atom_concat("son_of:", SonUUID, SonKey),
    atom_concat("", ParentUUID, Parent),
    redis(default, get(SonKey), UUID),
    UUID == Parent.

