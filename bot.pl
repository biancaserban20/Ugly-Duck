:-use_module(library(random)).
/*
The board is valued with an integer value from 0 to 1000.
The evaluation has to take into account the board and the player which "evaluates" the situation
0 is win for black.
1000 is win for white.
*/



%--- value( +GameState , -Value)
/* This function receives a Game State and returns the value of that Game State.
Again, a value greater than 500 means there is a slight advantage for the "white" player.
A value lower than 500 means there is an advantage for the "black" player.
The initial state has the value 500.
*/
value( S , 500 ):-
    initialState(S), !.

/*
The next 2 cases check if the game is won by one of the player.
If black has won, the value of the GameState is 0.
On the other hand, if white won tha game, the value is 1000.
*/
value(State, 0):-
    gameOver(State, b), !.

value(State, 1000):-
    gameOver(State, w), !.

/*
The next 2 cases check if the Player is in position to win imminently and
the Opponent can not opose.
The case described is if the White, for example, has a Swan on the 2nd line
and there are no Black pieces that can capture this swan. It is easy to
understand that the White will win no matter what.
*/
value([[L1,L2,L3,L4,L5], _], 999):-
    findall(
        Index,
        (
            nth1(IndexNumber, L2, ws),
            translate(Index, IndexNumber)
        ),
        ListIndex
    ),
    ListIndex \= [],
    findall(
        Move,
        (
            Move = [_ , _ ,Index, 2],
            memberchk(Index, ListIndex),
            validMove([L1, L2, L3, L4, L5], b, [_ , _ , Index, 2])
        ),
        []
    ), !.
    

value([[L1,L2,L3,L4,L5], _], 1):-
    findall(
        Index,
        (
            nth1(IndexNumber, L4, bs),
            translate(Index, IndexNumber)
        ),
        ListIndex
    ),
    ListIndex \= [],
    findall(
        Move,
        (
            Move = [_ , _ ,Index, 2],
            memberchk(Index, ListIndex),
            validMove([L1, L2, L3, L4, L5], w, [_ , _ , Index, 2])
        ),
        []
    ), !.


/*
Now, for the rest of the configurations, we will be using an heuristic that
we have defined. This function evaluates the board in the following way:
- any duck on the "home" line is 10 points
- the value of the duck increases with the distance it travels
    1st line = 10 points
    2nd line = 13 points
    3rd line = 16 points
    4th line = 19 points

- a newly-converted swan, that is on the "home" line of the opponent is evaluated at  30 points
- again, the value of the swan increases as it travels its way back home
    5th line (Opponent "home" line) = 30 points
    4th line = 45 points
    3rd line = 60 points
    2nd line = 90 points
*/
value([B, _] ,  Value):-
    evaluate(B , 1,  WhitePoints , BlackPoints),
    Value is (500 + WhitePoints - BlackPoints).


%--- evaluate(+Board, -WhitePiecesValue , - BlackPiecesValue)
/*
This is an auxiliary function that helps us with the evaluation of the board
in the way we described in the commentary above.
*/
evaluate( [ Line ], 5, White, Black):-
    count( Line , wd, 0),
    count( Line , ws, WhiteSwans),
    count( Line , bd, BlackDucks),
    count( Line , bs, 0),
    White is (30*WhiteSwans),
    Black is (10*BlackDucks).

evaluate( [ Line | T], 4, White, Black):-
    count( Line , wd, WhiteDucks),
    count( Line , ws, WhiteSwans),
    count( Line , bd, BlackDucks),
    count( Line , bs, BlackSwans),
    evaluate(T , 5, W ,B),
    White is (19*WhiteDucks + 45*WhiteSwans + W),
    Black is (13*BlackDucks + 90*BlackSwans + B).

evaluate( [ Line | T], 3, White, Black):-
    count( Line , wd, WhiteDucks),
    count( Line , ws, WhiteSwans),
    count( Line , bd, BlackDucks),
    count( Line , bs, BlackSwans),
    evaluate(T , 4, W ,B),
    White is (16*WhiteDucks + 60*WhiteSwans + W),
    Black is (16*BlackDucks + 60*BlackSwans + B).

evaluate( [ Line | T], 2, White, Black):-
    count( Line , wd, WhiteDucks),
    count( Line , ws, WhiteSwans),
    count( Line , bd, BlackDucks),
    count( Line , bs, BlackSwans),
    evaluate(T , 3, W ,B),
    White is (13*WhiteDucks + 90*WhiteSwans + W),
    Black is (19*BlackDucks + 45*BlackSwans + B).

evaluate( [ Line | T], 1, White, Black):-
    count( Line , wd, WhiteDucks),
    count( Line , ws, 0),
    count( Line , bd, 0),
    count( Line , bs, BlackSwans),
    evaluate(T , 2, W ,B),
    White is (10*WhiteDucks+ W),
    Black is (30*BlackSwans + B).


%--- pickBest(+State, -BestMove)
/*
This function makes a list with all pairs [valueBoard, validMove] for a given state.
Then it returns a Move that gives the player the best situation.
For the white player, the best move returns a Board with the maximum value.
For the black player, the best move return a Board with the minimum value.
*/
pickBest([Board, w], BestMove):-
    findall(
        [Value,Move],
        (
            move([Board, w], Move, [NB, b]),
            value([NB, b], Value)
        ),
        List
    ),
    sort(List, Sorted),
    reverse(Sorted, RevSorted),
    %print(RevSorted),
    randomBestMove( RevSorted, BestMove).

pickBest([Board, b], BestMove):-
    findall(
        [Value,Move],
        (
            move([Board, b], Move, [NB, w]),
            value([NB, w], Value)
        ),
        List
    ),
    sort(List, Sorted),
    %print(Sorted),
    randomBestMove( Sorted, BestMove).


%--- randomBestMove(+List of [Value, Move], -BestMove )
/*
This function choose randomly a Move that returns the best value. It is used
in order to choose randomly between equally valuable best moves.
This gives more flexibility for the SmartBot when playing against a Human or against
another Bot.
*/
randomBestMove( List, BestMove):-
    List = [ [BestValue, _] | _ ],
    findall(
        Move,
        (
            member( [BestValue , Move], List )
        ),
        MoveList
    ),
    random_member(BestMove, MoveList).

%--- count(+List, +Elem , -Occurences)
count([],_,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).





