/**
 * Check if row is valid on the board
 */
valid_row(Board, NRow) :-
    NRow >= 0,
    length(Board, NRows),
    NRow < NRows.


/**
 * Checks if column is valid on the board
 */
valid_column(Board, NRow, NColumn) :-
    NColumn >= 0,
    get_row(Board, NRow, Row),
    length(Row, NCols),
    NColumn < NCols.


/**
 * Checks if the position is valid on the board
 */
valid_position(Board, [NRow, NColumn], Stack) :-
    valid_row(Board, NRow),
    valid_column(Board, NRow, NColumn),
    get_stack(Board, [NRow, NColumn], Stack), !,
    Stack \= '_', !.


/**
 * Get a row of the board
 */
get_row([CurrentRow | _], 0, CurrentRow).
get_row([_ | Rest], NRow, OutRow) :-
    NRow > 0,
    N is NRow - 1,
    get_row(Rest, N, OutRow).


/**
 * Get a value from a row
 */
get_value([CurrentValue | _], 0, CurrentValue).
get_value([_ | Rest], NCol, OutValue) :-
    NCol > 0,
    N is NCol - 1,
    get_value(Rest, N, OutValue).


/**
 * Get a stack value from the board
 */
get_stack(Board, [NRow, NCol], Stack) :-
    get_row(Board, NRow, Row),
    get_value(Row, NCol, Stack), !.


/**
 * Change a row of the board
 */
set_row(_, _, _, NCols, NCols, NewRow, NewRow) :- !.

set_row([_ | Rest], NCol, NewValue, NCols, NCol, Acc, NewRow) :-
    NextCol is NCol + 1,
    append(Acc, [NewValue], NewAcc), !,
    set_row(Rest, NCol, NewValue, NCols, NextCol, NewAcc, NewRow).

set_row([Value | Rest], NCol, NewValue, NCols, CurrentCol, Acc, NewRow) :-
    NextCol is CurrentCol + 1,
    append(Acc, [Value], NewAcc), !,
    set_row(Rest, NCol, NewValue, NCols, NextCol, NewAcc, NewRow).


/**
 * Change a stack of the board
 */
set_stack(Board, Position, NewValue, NewBoard) :-
    length(Board, NRows),
    set_stack(Board, Position, NewValue, NRows, 0, [], NewBoard).

set_stack(_, _, _, NRows, NRows, NewBoard, NewBoard) :- !.

set_stack([Row | Rest], [NRow, NCol], NewValue, NRows, NRow, Acc, NewBoard) :-
    length(Row, NCols),
    set_row(Row, NCol, NewValue, NCols, 0, [], NewRow),
    NextRow is NRow + 1,
    append(Acc, [NewRow], NewAcc), !,
    set_stack(Rest, [NRow, NCol], NewValue, NRows, NextRow, NewAcc, NewBoard).

set_stack([Row | Rest], [NRow, NCol], NewValue, NRows, CurrentRow, Acc, NewBoard) :-
    NextRow is CurrentRow + 1,
    append(Acc, [Row], NewAcc), !,
    set_stack(Rest, [NRow, NCol], NewValue, NRows, NextRow, NewAcc, NewBoard).


/**
 * Get player stacks adjacent to stack on board
 */
get_adjacents(Board, Player, Position, Adjacents) :-
    directions(Directions),
    get_adjacents(Board, Player, Position, Directions, [], Adjacents), !.

get_adjacents(_, _, _, [], Adjacents, Adjacents) :- !.
get_adjacents(Board, Player, [Row, Column], [[RowInc, ColInc] | Rest], Acc, Adjacents) :-
    NewRow is Row + RowInc,
    NewCol is Column + ColInc, !,
    (
        valid_position(Board, [NewRow, NewCol], Stack),
        get_player(Stack, Player), !,
        append(Acc, [[NewRow, NewCol]], NewAcc)
        ;
        NewAcc = Acc
    ),
    get_adjacents(Board, Player, [Row, Column], Rest, NewAcc, Adjacents), !.


/**
 * Get Player Stack Positions
 */
get_player_stack_positions(Board, Player, StackPositions) :-
    get_player_stack_positions(Board, Player, [0,0], [], StackPositions).

get_player_stack_positions(_, _, [17, _], StackPositions, StackPositions).

get_player_stack_positions(Board, Player, [Row, Column], Acc, StackPositions) :-
    Column > 8,
    NewRow is Row + 1,
    NewColumn is 0,
    get_player_stack_positions(Board, Player, [NewRow, NewColumn], Acc, StackPositions).

get_player_stack_positions(Board, Player, [Row, Column], Acc, StackPositions) :-
    get_stack(Board, [Row, Column], Stack), !,
    (
        Stack \= '_',
        get_player(Stack, Player),
        append(Acc, [[Row, Column]], NewAcc)
        ;
        NewAcc = Acc
    ),
    NewColumn is Column + 1,
    get_player_stack_positions(Board, Player, [Row, NewColumn], NewAcc, StackPositions).
    
    
/** build_path(+Board, +Player, +Start, -Path)
 * Builds a path from start containing all the connected stacks from the Player
 */
build_path(Board, Player, Start, Visited, NewVisited, Path) :-
    build_path_helper(Board, Player, [Start], Visited, [], NewVisited, Path), !.

build_path_helper(_, _, [], Visited, Path, Visited, Path) :- !.
build_path_helper(Board, Player, [Top | Rest], CurrentVisited, Acc, Visited, Path) :-
    \+member(Top, CurrentVisited), !,
    append(CurrentVisited, [Top], NewVisited),
    (
        get_stack(Board, Top, Stack), !,
        get_player(Stack, Player),
        append(Acc, [Top], NewAcc), !,
        get_adjacents(Board, Player, Top, Adjacents), !,
        mark_all_non_visited(Rest, Adjacents, CurrentVisited, NewStack), !
        ;
        NewStack = Rest,
        NewAcc = Acc
    ),
    build_path_helper(Board, Player, NewStack, NewVisited, NewAcc, Visited, Path), !.

build_path_helper(Board, Player, [_ | Rest], CurrentVisited, Acc, Visited, Path) :-
    build_path_helper(Board, Player, Rest, CurrentVisited, Acc, Visited, Path), !.


/** mark_all_non_visited(+Stack, +List, +Visited, -NewStack)
 * Adds all the elements from list to stack that aren't in visited.
 */
mark_all_non_visited(Stack, List, Visited, OutStack) :-
    add_all_non_visited(Stack, List, Visited, OutStack), !.

add_all_non_visited(OutStack, [], _, OutStack) :- !.
add_all_non_visited(Stack, [Top | Rest], Visited, OutStack) :-
    (
        \+member(Top, Visited), !,
        append(Stack, [Top], NewStack)
        ;
        NewStack = Stack
    ),
    add_all_non_visited(NewStack, Rest, Visited, OutStack).


/**
 * Get empty Positions
 */
get_empty_positions(Board, Positions) :-
    get_empty_positions(Board, [0,0], [], Positions).

get_empty_positions(_, [17, _], Positions, Positions).

get_empty_positions(Board, [Row, Column], Acc, Positions) :-
    Column > 8,
    NewRow is Row + 1,
    NewColumn is 0,
    get_empty_positions(Board, [NewRow, NewColumn], Acc, Positions).

get_empty_positions(Board, [Row, Column], Acc, Positions) :-
    get_stack(Board, [Row, Column], Stack), !,
    (
        Stack = 0,
        append(Acc, [[Row, Column]], NewAcc)
        ;
        NewAcc = Acc
    ),
    NewColumn is Column + 1,
    get_empty_positions(Board, [Row, NewColumn], NewAcc, Positions).
    