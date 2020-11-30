/**
 * Choose a move to be played by a bot in Easy mode
 */
choose_move(Board, Player, 1, Move) :-
    valid_moves(Board, Player, Moves),
    length(Moves, N),
    random(1, N, ChoosenIndex),
    nth1(ChoosenIndex, Moves, Move), !.


/**
 * Choose a move to be played by a bot in Hard mode
 */
choose_move(Board, Player, 2, Move) :-
    getSortedByValueMoves(Board, Player, [_-Move | _]), !.


/**
 * Choose where the Easy bot should place a new stack
 */
choose_placing(Board, _, 1, Placing) :-
    get_empty_positions(Board, Placings),
    /*getSortedByValuePlacings(Board, Player, Placings),*/
    length(Placings, N),
    random(1, N, ChoosenIndex),
    nth1(ChoosenIndex, Placings, Placing), !.


/**
 * Choose where the Hard bot should place a new stack
 */
choose_placing(Board, Player, 2, Placing) :-
    getSortedByValuePlacings(Board, Player, [_-Placing | _]), !.


/**
 * Get the list of valid moves sorted by their value
 */
getSortedByValueMoves(Board, Player, Moves) :-
    valid_moves(Board, Player, ValidMoves),
    findall(
        Value-Move, 
        (
            member(Move, ValidMoves), 
            move(Board, Player, Move, NewBoard),
            value(NewBoard, Player, Value)
        ), 
        PossibleMoves
    ),
    sort(PossibleMoves, SortedMoves),
    reverse(SortedMoves, Moves), !.


/**
 * Get the list of valid placings sorted by their value
 */
getSortedByValuePlacings(Board, Player, Placings) :-
    get_empty_positions(Board, Positions),
    findall(
        Value-Placing, 
        (
            member(Placing, Positions), 
            place(Board, Player, Placing, NewBoard),
            value(NewBoard, Player, Value)
        ), 
        PossiblePlacings
    ),
    sort(PossiblePlacings, SortedPlacings),
    reverse(SortedPlacings, Placings), !.
    

/**
 * Get the value of a board
 * 
 * Algorithm
 * 1. For each stack of the player, calculate the connected stacks via DFS.
 * 
 * 2. For each connected region:
 *      2.1 For each board region calculate the number of unique columns (after board transformation) connected
 *          (board transformation results from a theoric rotation in order to align the opposite sides in a horizontal orientation)
 * 3. The final value of the connected region is the maximum value of the three regions of the board
 *
 * 4. The final value of the turn is the maximum value of the connected regions obtained previously
 */
value(Board, Player, Value) :-
    get_player_stack_positions(Board, Player, StackPositions),
    value(Board, Player, StackPositions, [], 0, Value), !.

value(_, _, [], _, Value, Value) :- !.

value(Board, Player, [ActiveCell | Rest], Visited, BestValue, Value) :-
    \+member(ActiveCell, Visited), !,
    build_path(Board, Player, ActiveCell, Visited, NewVisited, Path),
    path_value(Path, 1, ValueLR),
    path_value(Path, 2, ValueULBR),
    path_value(Path, 3, ValueURBL),
    max_positive([ValueLR, ValueULBR, ValueURBL, BestValue], NewBestValue), !,
    value(Board, Player, Rest, NewVisited, NewBestValue, Value), !.

value(Board, Player, [_ | Rest], Visited, BestValue, Value) :-
    value(Board, Player, Rest, Visited, BestValue, Value), !.


/**
 * Get the value of a path
 */
path_value(Path, Region, Value) :-
    path_value(Path, Region, [], Value), !.

path_value([], _, Acc, Value) :-
    length(Acc, Value), !.

path_value([Position | Rest], Region, Acc, Value) :-
    transform(Region, Position, Column), !,
    (
        \+member(Column, Acc),
        append(Acc, [Column], NewAcc)
        ;
        NewAcc = Acc
    ),
    path_value(Rest, Region, NewAcc, Value), !.