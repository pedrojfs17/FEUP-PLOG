/** next_player(+CurrentPlayer, -NextPlayer)
 * 
 * Determines player sequence
 * 
 */
next_player(p_red, p_yellow).
next_player(p_yellow, p_red).


/**
 * Checks if it is a player
 */
is_player(p_red).
is_player(p_yellow).


/**
 * Points to check in order to decide if game ended
 */
critical_points(
    [
    /* Upper right*/
    [0, 4], [1, 5], [2, 6], [3, 7], [4, 8],
    /* Upper left (excluding common point) */
    [4, 0], [1, 3], [2, 2], [3, 1],
    /* Left side (excluding common point) */
    [6, 0], [8, 0], [10, 0], [12, 0]
    ]
).


/** opposite_sides(+Side, -OppositeSide)
 * Gets the opposite side on the board
 */
opposite_sides([
    /* Upper Right - Bottom Left */
    [   [ [0, 4],   [1, 5],     [2, 6],     [3, 7],     [4, 8] ],
        [ [12, 0],  [13, 1],    [14, 2],    [15, 3],    [16, 4] ]
    ],
    /* Upper Left - Bottom Right */
    [   [ [0, 4],   [1, 3],     [2, 2],     [3, 1] ,    [4, 0] ],
        [ [12, 8],  [13, 7],    [14, 6],    [15, 5],    [16, 4] ]
    ],
    /* Left - Right */
    [   [ [4, 0],   [6, 0],     [8, 0],     [10, 0],     [12, 0] ],
        [ [4, 8],   [6, 8],     [8, 8],     [10, 8],     [12, 8] ]
    ]
]).


/** get_player(+Stack, -Player)
 * 
 * Red - Height less than 0
 * Yellow - Height greater than 0
 * Empty - Height equal to 0
 * 
 */
get_player(Stack, p_red) :-
    Stack < 0, !.
get_player(Stack, p_yellow) :-
    Stack > 0, !.
get_player(_, p_empty) :- !.


/**
 * Get the valid moves for a player
 */
valid_moves(Board, Player, Moves) :-
    get_player_stack_positions(Board, Player, StackPositions),
    valid_moves(Board, Player, StackPositions, [], Moves).

valid_moves(_, _, [], Moves, Moves).

valid_moves(Board, Player, [StackPosition | Rest], Acc, Moves) :-
    valid_moves_position(Board, Player, StackPosition, StackMoves),
    addMovesToList(Acc, StackPosition, StackMoves, NewAcc),
    valid_moves(Board, Player, Rest, NewAcc, Moves).


/**
 * Get the valid moves for a given position
 */
valid_moves_position(Board, Player, Position, Moves) :-
    valid_moves_position(Board, Player, Position, 0, [], Moves).

valid_moves_position(_, _, _, 6, Moves, Moves).

valid_moves_position(Board, Player, Position, Direction, Acc, Moves) :-
    direction(Direction, _, _),
    NewDirection is Direction + 1,
    valid_moves_direction(Board, Player, Position, Direction, DirectionMoves),
    length(DirectionMoves, N),
    (
        N > 0, 
        addMovesToList(Acc, [Direction], DirectionMoves, NewAcc)
        ;
        NewAcc = Acc
    ),
    valid_moves_position(Board, Player, Position, NewDirection, NewAcc, Moves).


/**
 * Get valid moves for a given position in a given direction
 */
valid_moves_direction(Board, Player, Position, Direction, Moves) :-
    get_stack(Board, Position, Stack),
    StackValue is abs(Stack),
    get_integer_partitions(StackValue, Partitions),
    valid_moves_direction(Board, Player, Position, Direction, Partitions, [], Moves).


valid_moves_direction(_, _, _, _, [], Moves, Moves).

valid_moves_direction(Board, Player, [Row, Column], Direction, [Partition | Rest], Acc, Moves) :-
    length(Partition, NStacks), !,
    (
        validate_move(Board, [Row, Column, Direction, NStacks, Partition], Player), !,
        append(Acc, [[NStacks, Partition]], NewAcc)
        ;
        NewAcc = Acc
    ), !,
    valid_moves_direction(Board, Player, [Row, Column], Direction, Rest, NewAcc, Moves).


/** validate_stack_height(+Board, +Position)
 *
 * Checks if a stack is valid to divide into substacks
 * 
 */
validate_stack_height(Board, Position) :-
    get_stack(Board, Position, Height),
    abs(Height) > 2, !.


/** validate_move(+Board, +Move, +Player)
 *
 * Checks if a move is valid or not
 * 
 */
validate_move(Board, [NRow, NColumn, Direction, NStacks, Stacks], Player) :-
    NStacks > 0,
    valid_position(Board, [NRow, NColumn], _), !,
    validate_stack_height(Board, [NRow, NColumn]), !,
    validate_move(Board, [NRow, NColumn, Direction, NStacks, Stacks], 0, Player), !.

validate_move(Board, [NRow, NColumn, _, _, []], StackSum, Player) :-
    get_stack(Board, [NRow, NColumn], OriginalStack), !,
    get_player(OriginalStack, Player),
    StackSum =:= abs(OriginalStack), !.

validate_move(Board, [NRow, NColumn, Direction, NStacks, [Stack | Rest]], StackSum, Player) :-
    direction(Direction, RowIncrement, ColumnIncrement),
    StackRow is (NRow + abs(Stack) * RowIncrement),
    StackColumn is (NColumn + abs(Stack) * ColumnIncrement),
    get_stack(Board, [StackRow, StackColumn], StackToReplace), !,
    StackToReplace \= '_',
    get_player(StackToReplace, Player2),
    (Player = Player2; abs(Stack) >= abs(StackToReplace)), !,
    NewStackSum is StackSum + abs(Stack),
    validate_move(Board, [NRow, NColumn, Direction, NStacks, Rest], NewStackSum, Player), !.


/** move(+Board, +Player, +Move, -NewBoard)
 * 
 * Separate and move a stack
 *
 * Base case - Resets initial stack position no empty
 * Recursive case - Changes the value of the current stack position
 * 
 */
move(Board, _, [NRow, NColumn, _, _, []], NewBoard) :-
    set_stack(Board, [NRow, NColumn], 0, NewBoard).

move(Board, Player, [NRow, NColumn, Direction, NStacks, [Stack | Rest]], NewBoard) :-
    N is NStacks - 1,
    direction(Direction, RowIncrement, ColumnIncrement),
    StackRow is (NRow + abs(Stack) * RowIncrement),
    StackColumn is (NColumn + abs(Stack) * ColumnIncrement),
    calculate_stack_value(Board, [StackRow, StackColumn], Player, Stack, StackValue),
    set_stack(Board, [StackRow, StackColumn], StackValue, CumulativeBoard),
    move(CumulativeBoard, Player, [NRow, NColumn, Direction, N, Rest], NewBoard).


/** calculate_stack_value(+Board, +Position, +Player, +Stack, -StackValue)
 * 
 * Calculate the new stack value acording to the player who is playing
 * 
 */
calculate_stack_value(Board, Position, Player, Stack, StackValue) :-
    Player = p_red,
    get_stack(Board, Position, CurrentStack),
    StackValue is - (abs(Stack) + abs(CurrentStack)), !.

calculate_stack_value(Board, Position, _, Stack, StackValue) :-
    get_stack(Board, Position, CurrentStack),
    StackValue is (abs(Stack) + abs(CurrentStack)), !.
    

/** place(+Board, +Player, +Position, -NewBoard)
 * 
 * Places a new stack of height 1 on the board
 * 
 */
place(Board, Player, Position, NewBoard) :-
    Player = p_red,
    set_stack(Board, Position, -1, NewBoard), !.

place(Board, _, Position, NewBoard) :-
    set_stack(Board, Position, 1, NewBoard), !.


/**
 * Checks if the player has no moves left
 */
game_over(Board, Player, Result) :-
    valid_moves(Board, Player, Moves),
    length(Moves, NMoves), !,
    %get_number_of_valid_moves(Moves, NMoves), !,
    (
        NMoves = 0,
        next_player(Player, Result)
        ;
        game_over(Board, Result)
    ), !.


/**
 * Checks if any player has won by connecting two sides
 */
game_over(Board, Result) :-
    critical_points(CriticalPoints),
    verify_all_points(Board, CriticalPoints, Result), !,
    is_player(Result), !.


/**
 * Iterates through every critical point and checks if two opposite sides are connected
 */
verify_all_points(Board, Points, Result) :-
    verify_all_points(Board, Points, [], Result), !.

verify_all_points(_, [], _, p_empty) :- !.

verify_all_points(Board, [Cell | Rest], Visited, Result) :-
    \+member(Cell, Visited),
    get_stack(Board, Cell, Stack),
    get_player(Stack, Player),
    is_player(Player), !,
    build_path(Board, Player, Cell, Visited, NewVisited, Path), !,
    (
        has_opposite_sides(Path),
        Result = Player
        ;
        verify_all_points(Board, Rest, NewVisited, Result)
    ), !.

verify_all_points(Board, [Cell | Rest], Visited, Result) :-
    append(Visited, [Cell], NewVisited),
    verify_all_points(Board, Rest, NewVisited, Result), !.


/**
 * Checks if a path is connecting any two opposite sides
 */
has_opposite_sides(Path) :-
    opposite_sides(Sides),
    has_opposite_sides(Path, Sides), !.

has_opposite_sides(Path, [[Key, Opposite] | _]):-
    has_common_elements(Path, Key),
    has_common_elements(Path, Opposite), !.

has_opposite_sides(Path, [_ | Rest]) :-
    has_opposite_sides(Path, Rest), !.