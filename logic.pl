:- use_module(library(between)).
:- use_module(library(lists)).
:- use_module(library(random)).

initialBoard(
    [
        [wd,wd,wd,wd,wd],
        [e,e,e,e,e],
        [e,e,e,e,e],
        [e,e,e,e,e],
        [bd,bd,bd,bd,bd]
    ]
).
initialState(
    [
        [
        [wd,wd,wd,wd,wd],
        [e,e,e,e,e],
        [e,e,e,e,e],
        [e,e,e,e,e],
        [bd,bd,bd,bd,bd]
        ],
        w
    ]
).

intermediateBoard1(
    [
        [wd, e, e, e, bs],
        [e, bd, e, bs, e],
        [wd, e, ws, e, e],
        [e,  bd, e, e, e],
        [e,  e,  e, e, e]
    ]
).

intermediateState1(
    [
        [
        [wd, e, e, e, bs],
        [e, bd, e, bs, e],
        [wd, e, ws, e, e],
        [e,  bd, e, e, e],
        [e,  e,  e, e, e]
        ],
        b
    ]
).

intermediateState2(
    [
        [
            [ws,e,e,e,e],
            [wd,e,e,e,e],
            [bd,e,e,e,e],
            [bd,e,e,e,e],
            [ws,e,e,e,e]
        ],
        b
    ]
).

%--- nextPlayer(?Player1, ?Player2)

nextPlayer(w, b).
nextPlayer(b, w).

%--- move(+GameState, +Move, NewGameState)

move([B , P1], Move, [NB , P2]):-
    nextPlayer(P1, P2),
    validMove(B, P1, Move),
    makeMove(B, Move, NB).


%--- validMove(+Board, +Player, ?Move)
/* This function checks if the given move made by
the given player is a valid move. */

validMove(B , w , [X, Y, Nx, Ny]):-
    translate(X, Xt),
    translate(Nx, Nxt),
    between(1,5,Xt),
    between(1,5,Nxt),
    between(1,5,Y),
    between(1,5,Ny),
    nth1(Ny, B, NLinia),
    nth1(Nxt, NLinia, Adversarul),
    nth1(Y, B, Linia),
    nth1(Xt, Linia, Elementul),
    (
        (
            Elementul = ws,
            Ny is (Y-1),
            (
                (Adversarul = e, abs(Xt- Nxt) =< 1);
                ((Adversarul = bd; Adversarul = bs), abs(Xt-Nxt) =:= 1)
            )
        );
        (
            Elementul = wd,
            Ny is (Y+1),
            (
                (
                    Adversarul = e,
                    abs(Xt- Nxt) =< 1
                );
                (
                    (
                        Adversarul = bd;
                        Adversarul = bs
                    ),
                    abs(Xt-Nxt) =:= 1
                )
            )
        )
).

validMove(B , b , [X, Y, Nx, Ny]):-
    translate(X, Xt),
    translate(Nx, Nxt),
    between(1,5,Xt),
    between(1,5,Nxt),
    between(1,5,Y),
    between(1,5,Ny),
    nth1(Ny, B, NLinia),
    nth1(Nxt, NLinia, Adversarul),
    nth1(Y, B, Linia),
    nth1(Xt, Linia, Elementul),
    (
        (
            Elementul = bs,
            Ny is (Y+1),
            (
                (Adversarul = e, abs(Xt- Nxt) =< 1);
                ((Adversarul = wd; Adversarul = ws), abs(Xt-Nxt) =:= 1)
            )
        );
        (
            Elementul = bd,
            Ny is (Y-1),
            (
                (
                    Adversarul = e,
                    abs(Xt- Nxt) =< 1
                );
                (
                    (
                        Adversarul = wd;
                        Adversarul = ws
                    ),
                    abs(Xt-Nxt) =:= 1
                )
            )
        )
).

%--- makeMove(+Board, +Move, -NewBoard)
/* This function executes the given move on the given board and returns the new board.
The move is made by blindly replacing the "destination" cell with the value of the "origin" cell.
The "origin" cell will get the value 'e' (empty).
It is recommended that the move has been previously checked
with the validMove/3 predicate.
*/

makeMove(B , [X, Y, Nx, Ny], NB):-
    translate(X, Xt),
    translate(Nx, Nxt),

    nth1( Y , B, Linie),
    nth1( Xt, Linie, Piesa),

    replaceMatrix( B, [Ny,Nxt], Piesa, B1 ),
    replaceMatrix( B1 , [Y,Xt] , e , B2 ),
    convertSwans(B2, NB).


%--- replaceMatrix(+Matrix, +[Line, Column], +Elem, -NewMatrix)
/* This function receives a matrix and a pair of coordinates and
replaces the existent item at those coordinates with the given "Elem".
The modified matrix is returned.
The indexation starts from 1 on both dimensions.
*/
replaceMatrix( [H1 | T], [1, Y], Elem , [H2| T] ):-
    nth1( Y, H1, _, R ),
    nth1( Y, H2, Elem, R), !.


replaceMatrix( [H|T] , [X, Y], E , [H | T2] ):-
    X > 1,
    Nx is X-1,
    replaceMatrix( T, [Nx, Y], E , T2).

%--- convertSwans(+Board , -NewBoard)
/* This function converts all the duck that arrived on the
opposite last row into swans.
*/
convertSwans([L1, L2 , L3 , L4 , L5] , [NL1, L2, L3, L4, NL5]):-
    replace(bd, L1, bs, NL1),
    replace(wd, L5, ws, NL5).

%--- replace(+OldElem, +OldList, +NewElem, -NewList)
/* Replaces all the occurences of "OldElem" in the 
"OldList" with "NewElem". The new list is returned.
*/
replace(_ , [] , _ , []).

replace(E , [E | T], N, [N | T2]):-
    replace(E, T, N ,T2).
replace(E, [H | T], N , [H | T2]):-
    E \= H,
    replace(E, T , N ,T2).


%--- translate(?Letter, ?Digit)
translate(a, 1).
translate(b, 2).
translate(c, 3).
translate(d, 4).
translate(e, 5).

%--- gameOver(+GameState, -Winner).
/* This functions receives a Game State and returns the letter
of the Winner, if that is the case.
A Player wins if it has a Swan on their "home" line or the Opponent
does not have any more pieces on the table.
*/
gameOver([ [_, _, _ , _ , L5], _], b ):-
    memberchk(bs, L5), !.

gameOver( [Board, _], b):-
    zeroPieces(Board, w).

gameOver([ [L1, _, _, _, _], _], w ):-
    memberchk(ws, L1), !.

gameOver( [Board, _], w):-
    zeroPieces(Board, b).

%--- zeroPieces(+Board, +Player)
/* This function checks if the given Player has 0 pieces
left on the table.
*/

zeroPieces( [] , _).
zeroPieces( [H | T], w):-
    count(H , ws, 0),
    count(H, wd, 0),
    zeroPieces(T, w).

zeroPieces( [H | T], b):-
    count(H , bs, 0),
    count(H, bd, 0),
    zeroPieces(T, b).
    

%--- validMoves(+GameState,-ListOfMoves).

validMoves([Board, Player], LMoves):-
    findall( 
        Move,
        (
            validMove(Board, Player, Move)
        ),
        LMoves
    ).

%--- chooseMove(+GameState, -Move).

chooseMove( S , Move):-
    validMoves(S, List),
    random_member(Move, List).