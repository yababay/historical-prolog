:- module(ввод_вывод, [
    читать_текст_из_файла/2,
    вывести_на_экран/1
]).

читать_текст_из_файла(File, Chars) :-
    open(File, read, Stream),
    get_char(Stream, Char),
    читать_текст_из_файла(Stream, Char, Chars),
    close(Stream).

читать_текст_из_файла(Stream, Char, Chars) :-
    (   Char == end_of_file ->
        Chars = []
    ;   Chars = [Char| Rest],
        get_char(Stream, Next),
        читать_текст_из_файла(Stream, Next, Rest)
    ).

вывести_на_экран([]) :- nl,!.

вывести_на_экран([L]) :- 
    format("~w", [L]), nl,!.

вывести_на_экран([H|T]) :-
    format("~w", [H]), nl,
    вывести_на_экран(T).

