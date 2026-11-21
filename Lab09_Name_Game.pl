% Lab 9 - IO Stream and Database Manipulation
% Name Game

:- dynamic letters/1.

start :-
    retractall(letters(_)),
    assertz(letters([a,b,c])),
    write('Hi, This is the "Name Game".'), nl,
    write('Create your name by adding, moving or deleting letters.'), nl,
    menu.

menu :-
    nl,
    write('Choose from the following:'), nl,
    write('1- Display the current set of letters'), nl,
    write('2- Add a letter at a chosen position'), nl,
    write('3- Add a letter at the top'), nl,
    write('4- Add a letter at the bottom'), nl,
    write('5- Delete a letter'), nl,
    write('6- Delete all letters'), nl,
    write('7- Exit'), nl,
    write('8- Move a letter'), nl,
    write('Enter your choice: '),
    read(Choice),
    handle_choice(Choice).

handle_choice(1) :-
    letters(L),
    write('Current letters: '), write(L), nl,
    menu.
handle_choice(2) :-
    write('Enter a lowercase letter: '),
    read(Letter),
    write('Enter the position (starting from 1): '),
    read(Position),
    letters(L),
    insert_at(L, Letter, Position, NewList),
    !,
    update_letters(NewList),
    write('Letter added.'), nl,
    menu.
handle_choice(2) :-
    write('Invalid position.'), nl,
    menu.
handle_choice(3) :-
    write('Enter a lowercase letter: '),
    read(Letter),
    letters(L),
    update_letters([Letter|L]),
    write('Letter added at the top.'), nl,
    menu.
handle_choice(4) :-
    write('Enter a lowercase letter: '),
    read(Letter),
    letters(L),
    append(L, [Letter], NewList),
    update_letters(NewList),
    write('Letter added at the bottom.'), nl,
    menu.
handle_choice(5) :-
    write('Enter the letter to delete: '),
    read(Letter),
    letters(L),
    ( select(Letter, L, NewList) ->
        update_letters(NewList),
        write('Letter deleted.'), nl
    ;
        write('Letter not found.'), nl
    ),
    menu.
handle_choice(6) :-
    update_letters([]),
    write('All letters deleted.'), nl,
    menu.
handle_choice(7) :-
    write('Goodbye!'), nl.
handle_choice(8) :-
    write('Enter the letter to move: '),
    read(Letter),
    write('Enter its new position (starting from 1): '),
    read(Position),
    letters(L),
    ( select(Letter, L, Remaining),
      insert_at(Remaining, Letter, Position, NewList) ->
        update_letters(NewList),
        write('Letter moved.'), nl
    ;
        write('Letter or position is invalid.'), nl
    ),
    menu.
handle_choice(_) :-
    write('Invalid choice. Please choose from 1 to 8.'), nl,
    menu.

update_letters(NewList) :-
    retractall(letters(_)),
    assertz(letters(NewList)).

% Insert an item at a 1-based position.
insert_at(List, Item, 1, [Item|List]).
insert_at([Head|Tail], Item, Position, [Head|NewTail]) :-
    integer(Position),
    Position > 1,
    Next is Position - 1,
    insert_at(Tail, Item, Next, NewTail).


:- initialization(start).
