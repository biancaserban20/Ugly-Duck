/* --- printMenu/0
Prints the menu of the Game.
*/
printMenu:-
    format('~n~`*t ~p ~`*t ~50|~n', ['Menu']),                  %Title line
    format('*~t * ~50|~n', []),                                 %empty line
    format('*~t ~p ~t * ~50|~n', ['Options']),                  %options line
    format('*~t * ~50|~n', []),                                 
    format('*~t ~p ~t ~p ~t * ~50|~n', [1, 'Player vs Player']),
    format('*~t  ~p ~t ~p ~t * ~50|~n', [2, 'DumbBot vs DumbBot']),
    format('*~t  ~p ~t ~p ~t * ~50|~n', [3, 'Player vs DumbBot']),
    format('*~t  ~p ~t ~p ~t * ~50|~n', [4, 'DumbBot vs Player']),
    format('*~t   ~p ~t ~p ~t * ~50|~n', [5, 'SmartBot vs SmartBot']),
    format('*~t  ~p ~t ~p ~t * ~50|~n', [6, 'SmartBot vs Player']),
    format('*~t  ~p ~t ~p ~t * ~50|~n', [7, 'Player vs SmartBot']),
    format('*~t  ~p ~t ~p ~t * ~50|~n', [8, 'DumbBot vs SmartBot']),
    format('*~t  ~p ~t ~p ~t * ~50|~n', [9, 'SmartBot vs DumbBot']),
    format('*~t ~p ~t ~p ~t * ~50|~n', [i, 'Game Instructions']),
    format('*~t~p ~t ~p ~t * ~50|~n', [e, 'Exit the Game']),
    format('*~t * ~50|~n', []),
    format('* ~t ~p ~t * ~50|~n', ['!Player1 vs Player2 = White vs Black!']),
    format('*~t * ~50|~n', []),
    format('~`*t ~50|~n', []),
    write('Choose your option and press enter. ').

/* --- printInstructions/0
Prints the Instructions of the Game.
*/
printInstructions:-
        format('~n~`*t ~p ~`*t ~100|~n', ['Instructions']),         
        format('*~t * ~100|~n', []),                        
        format('*~t ~p ~t * ~100|~n', ['Ugly Duck is played on a 5x5 board']),
        format('*~t * ~100|~n', []), 
        format('*~t ~p ~t * ~100|~n', ['DUCK - A duck moves one cell orthogonal and diagonal forward']),
        format('*~t ~p ~t * ~100|~n', ['Ducks capture diagonal forward. Captures are not mandatory.']),
        format('*~t ~p ~t * ~100|~n', ['A duck reaching last row is promoted to a swan.']),
        format('*~t * ~100|~n', []), 
        format('*~t ~p ~t * ~100|~n', ['SWAN - A swan moves one cell orthogonal and diagonal backward']),
        format('*~t ~p ~t * ~100|~n', ['Swans capture diagonal backward. Captures are not mandatory.']),
        format('*~t * ~100|~n', []),
        format('*~t ~p ~t * ~100|~n', ['GOAL - Wins the player who first moves a swan into his first row']),
        format('*~t * ~100|~n', []),
        format('~`*t ~100|~n', []).

/* ---displayBoard(+Board)
Prints a line with the letters of each column of the board,
transforms the Board and prints it line by line.
*/


displayBoard(Board):- 
                format('~n      |  ~p |  ~p |  ~p |  ~p |  ~p |~30|~n', ['a','b','c','d','e']),
                format('~`-t~33|~n', []),
                trans(Board, NewBoard),
                displayBoardAux(NewBoard, 1).

/* --- displayBoardAux(+Board, +LineNo)
Prints the board line by line until the LineNo
reaches 6, as the board has 5 lines.
Before each line of the Board, the LineNo is added. 
*/

displayBoardAux(_, 6):-!.

displayBoardAux(Board, N):-
                    N =< 5,
                    nth1(N, Board, Line),
                    format('  ~p   | ~p | ~p | ~p | ~p | ~p |~n', [N|Line]),
                    format('~`-t~33|~n', []),
                    NewN is N + 1,
                    displayBoardAux(Board, NewN).


/* --- trans(+LineWithE, -LineWithSpace)
Transforms the internal representation of the board which
contains 'e' as an empty cell into another board which 
contains '  ' (double space).
Therefore, it receives a line with 'e' as empty spaces
and it will return a line with '  '.
*/
trans([] , [] ).

trans([H | T], [H2 | T2]):-
    transAux(H , H2),
    trans(T, T2).

transAux( [] , [] ).
transAux( [e | T ], ['  '| T2]):-
    transAux(T,  T2).
transAux( [H | T], [H | T2]):-
    H \= e,
    transAux(T, T2).


/*--- displayGame(+GameState)
Prints the Board and "announces" whose turn it is (White or Black).
*/
displayGame([Board, w]):-
                        displayBoard(Board),
                        format('~p, it is your turn!~n', ['White']).

displayGame([Board, b]):-
                        displayBoard(Board),
                        format('~p, it is your turn!~n', ['Black']).

/*--- congratsMsg(+Winner)
Prints the Winner and the Loser of the Game.
*/
congratsMsg(w):-
            format('~p, Congrats! You won!~n', ['White']),
            format('~p, Game Over! Good luck next time!~n', ['Black']).
                                                                                                                                     
                                                                                        
congratsMsg(b):-
            format('~p, Congrats! You won!~n', ['Black']),
            format('~p, Game Over! Good luck next time!~n', ['White']).




%----- readInputCoord(-SourceLine, -SourceColumn, -DestinationLine, -DestinationColumn)
readInputCoord(Xs, Ys, Xd, Yd):- 
            writeMsgCoord,
            readCoord(Xs, Ys, Xd, Yd).
            
readCoord(Xs, Ys, Xd, Yd):-
                repeat,
                write('Where is the duck/swan you want to move?'),
                nl,
                write('->Line [1-5]: '),
                get_code(XsCode),
                clear_buffer,
                Xs is XsCode-48,
                write('->Column [a-e]: '),
                get_char(Ys),
                clear_buffer,
                %coordOk(Xs,Ys),
                write('Where do you want to move it?'),
                nl,
                write('->Line [1-5]: '),
                get_code(XdCode),
                clear_buffer,
                Xd is XdCode-48,
                write('->Column [a-e]: '),
                get_char(Yd),
                clear_buffer, !.
                %coordOk(Xd, Yd), !.
                



%--- coordOk( +Line, +Col)
coordOk( X, Y):-
    translate( Y, _),
    between(1,5, X).

writeMsgCoord:-
    nl,
    write('Quack! Quack! Tell me your move, human!'),
    nl,
    write('Respect the limits! Otherwise, I will ask your move again and I will quack all day!'),
    nl.
