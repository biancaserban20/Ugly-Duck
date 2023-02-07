:- use_module(library(lists)).
:- use_module(library(system)).

:-ensure_loaded('logic.pl').
:-ensure_loaded('inout.pl').
:-ensure_loaded('gameModes.pl').
:-ensure_loaded('bot.pl').


/*--- play/0 
Used for starting the game: displays the Menu, reads your choice and and follows that choice
*/
play:-
    printMenu,
    get_char(X),
    clear_buffer,
    chosenOptionMenu(X).

/*--- chosenOptionMenu(+Option)
Prints the option you chose and according to the option, does the following:
  - starts the game in the chosen mode
  - or prints the game Instructions
  - or exists the game.
Another kind of input is not allowed.
*/
chosenOptionMenu('1'):- 
    format('You have chosen ~p. ~n', ['Player vs Player']),
    !,
    initialState(X),
    playerVsPlayer(X).

chosenOptionMenu('2'):-
    format('You have chosen ~p. ~n', ['DumbBot vs DumbBot']),
    !,
    initialState(X),
    computerVsComputer(X).

chosenOptionMenu('3'):- 
    format('You have chosen ~p. ~n', ['Player vs DumbBot']),
    !,
    initialState(X),
    playerVsComputer(X).

chosenOptionMenu('4'):- 
    format('You have chosen ~p. ~n', ['DumbBot vs Player']),
    !,
    initialState(X),
    computerVsPlayer(X).
chosenOptionMenu('5'):- 
    format('You have chosen ~p. ~n', ['SmartBot vs SmartBot']),
    !,
    initialState(X),
    smartVsSmart(X).

chosenOptionMenu('6'):- 
    format('You have chosen ~p. ~n', ['SmartBot vs Player']),
    !,
    initialState(X),
    smatrtVsPlayer(X).

chosenOptionMenu('7'):- 
    format('You have chosen ~p. ~n', ['Player vs SmartBot']),
    !,
    initialState(X),
    playerVsSmart(X).

chosenOptionMenu('8'):- 
    format('You have chosen ~p. ~n', ['DumbBot vs SmartBot']),
    !,
    initialState(X),
    dumbVsSmart(X).

chosenOptionMenu('9'):- 
    format('You have chosen ~p. ~n', ['SmartBot vs DumbBot']),
    !,
    initialState(X),
    smartVsDumb(X).

chosenOptionMenu(i):- 
                printInstructions,
                optionsInstructions, !.

chosenOptionMenu(e):- format('~p ~n', ['Game closed!']), !.

chosenOptionMenu(X):-
                format('The option ~p does not exist. Please try again!~n', [X]),
                play.

/* --- optionsInstructions/0
Reads your choice and follows it.
*/
optionsInstructions:- 
                write('Type "b" to go back to the menu or type "e" to exit the game. '),
                get_char(X),
                clear_buffer,
                chosenOptionInstruction(X).

/* --- chosenOptionInstruction(+Option)
There are 2 valid options: 
    - exit the Game
    - get back to the menu
Another kind of input is not allowed.
*/
chosenOptionInstruction(b):- play, !.
chosenOptionInstruction(e):- format('~p ~n', ['Game closed!']), !.
chosenOptionInstruction(X):-
                        format('The option "~p" does not exist. Please try again!~n', [X]),
                        optionsInstructions.


% clear_buffer.
% Clears the input buffer.
clear_buffer:-
    repeat,
    get_char(C),
    C = '\n'.
