%-------------------Player vs Player----------------------------

/*--- playerVsPlayer(+GameState).
*/
playerVsPlayer(GameState):-
            gameOver(GameState, X), !,
            displayBoard(B),
            congratsMsg(X).

playerVsPlayer([Board , Player]):-
            repeat,
            displayGame([Board , Player]),
            readInputCoord(Xs,Ys, Xd, Yd),
            move([Board,Player],  [Ys,Xs, Yd, Xd], NS),
            !,
            playerVsPlayer(NS).




%-----------------Player vs Computer----------------------------
playerVsComputer([B,P]):-
            gameOver([B,P], X), !,
            displayBoard(B),
            congratsMsg(X).

playerVsComputer([Board , w]):- 
            repeat,
            displayGame([Board ,w]),
            readInputCoord(Xs,Ys, Xd, Yd),
            move([Board,w],  [Ys,Xs, Yd, Xd], NS),
            !,
            playerVsComputer(NS).

playerVsComputer([Board , b]):- 
            displayGame([Board ,b]),
            chooseMove([Board, b], Move),
            move([Board,b],  Move, NS),
            !,
            playerVsComputer(NS).

%------------------------Computer vs Player----------------------
computerVsPlayer([B,P]):-
            gameOver([B,P], X), !,
            displayBoard(B),
            congratsMsg(X).
            
computerVsPlayer([Board , b]):- 
            repeat,
            displayGame([Board ,b]),
            readInputCoord(Xs,Ys, Xd, Yd),
            move([Board,b],  [Ys,Xs, Yd, Xd], NS),
            !,
            computerVsPlayer(NS).

computerVsPlayer([Board , w]):- 
            displayGame([Board ,w]),
            chooseMove([Board, w], Move),
            move([Board,w],  Move, NS),
            !,
            computerVsPlayer(NS).


%---------------------Computer vs Computer-----------------------
computerVsComputer([B,P]):-
            gameOver([B,P], X), !,
            displayBoard(B),
            congratsMsg(X).
            
computerVsComputer([Board , b]):- 
            displayGame([Board ,b]),
            sleep(3),
            chooseMove([Board, b], Move),
            move([Board,b], Move, NS),
            !,
            computerVsComputer(NS).

computerVsComputer([Board , w]):-
            displayGame([Board ,w]),
            sleep(3),
            chooseMove([Board, w], Move),
            move([Board,w],  Move, NS),
            !,
            computerVsComputer(NS).

%---------------------SmartComputer vs SmartComputer-----------------------
smartVsSmart([B,P]):-
            gameOver([B,P], X), !,
            displayBoard(B),
            congratsMsg(X).
            
smartVsSmart([Board , b]):- 
            displayGame([Board ,b]),
            sleep(3),
            pickBest([Board, b], Move),
            move([Board,b], Move, NS),
            !,
            smartVsSmart(NS).

smartVsSmart([Board , w]):-
            displayGame([Board ,w]),
            sleep(3),
            pickBest([Board, w], Move),
            move([Board,w],  Move, NS),
            !,
            smartVsSmart(NS).

%---------------------SmartComputer vs Player-----------------------
smartVsPlayer([B,P]):-
            gameOver([B,P], X), !,
            displayBoard(B),
            congratsMsg(X).
            
smartVsPlayer([Board , b]):- 
            repeat,
            displayGame([Board ,b]),
            readInputCoord(Xs,Ys, Xd, Yd),
            move([Board,b],  [Ys,Xs, Yd, Xd], NS),
            !,
            smartVsPlayer(NS).

smartVsPlayer([Board , w]):-
            displayGame([Board ,w]),
            pickBest([Board, w], Move),
            move([Board,w],  Move, NS),
            !,
            smartVsSmart(NS).

%---------------------Player vs SmartComputer-----------------------
playerVsSmart([B,P]):-
            gameOver([B,P], X), !,
            displayBoard(B),
            congratsMsg(X).
            
playerVsSmart([Board , b]):-
        displayGame([Board ,b]),
        pickBest([Board, b], Move),
        move([Board,b], Move, NS),
        !,
        playerVsSmart(NS).

playerVsSmart([Board , w]):-
            repeat,
            displayGame([Board ,w]),
            readInputCoord(Xs,Ys, Xd, Yd),
            move([Board,w],  [Ys,Xs, Yd, Xd], NS),
            !,
            playerVsSmart(NS).
        
%---------------------DumbBot vs Smartbot-----------------------
dumbVsSmart([B,P]):-
            gameOver([B,P], X), !,
            displayBoard(B),
            congratsMsg(X).
            
dumbVsSmart([Board , b]):-
        displayGame([Board ,b]),
        sleep(3),
        pickBest([Board, b], Move),
        move([Board,b], Move, NS),
        !,
        dumbVsSmart(NS).

dumbVsSmart([Board , w]):-
       displayGame([Board ,w]),
        sleep(3),
        chooseMove([Board, w], Move),
        move([Board,w],  Move, NS),
        !,
        dumbVsSmart(NS).

%---------------------SmartBot vs Dumbbot-----------------------
smartVsDumb([B,P]):-
            gameOver([B,P], X), !,
            displayBoard(B),
            congratsMsg(X).
            
smartVsDumb([Board , b]):-
        displayGame([Board ,b]),
        sleep(3),
        chooseMove([Board, b], Move),
        move([Board,b], Move, NS),
        !,
        smartVsDumb(NS).

smartVsDumb([Board , w]):-
        displayGame([Board ,w]),
        sleep(3),
        pickBest([Board, w], Move),
        move([Board,w],  Move, NS),
        !,
        smartVsDumb(NS).