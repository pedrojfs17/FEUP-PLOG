/**
 * Reads a number from input (0-9)
 */
read_number(Number) :-
    get_code(Code), skip_line,
    Code >= 48, Code < 58,
    Number is Code - 48.


/**
 * Reads a letter from input (a-Z)
 */
read_char(Char) :-
    get_code(Code), skip_line,
    UppercaseCode is Code /\ \(32),
    UppercaseCode >= 65, UppercaseCode < 91,
    char_code(Char, UppercaseCode).


/**
 * Reads the heights of the substacks
 */
read_stack_heights(NStacks, HeightList) :-
    read_stack_heights(NStacks, [], HeightList).

read_stack_heights(0, HeightList, HeightList) :- !.
read_stack_heights(NStacks, Acc, HeightList) :-
    write('   -> Enter height for substack: '),
    read_number(N),
    NextNStacks is NStacks - 1,
    \+member(N, Acc),
    read_stack_heights(NextNStacks, [N | Acc], HeightList).


/**
 * Reads a valid position from input
 */
read_position(Board, Player, Row, Column, Moves) :-
    repeat,
    write('-> Enter Row (A-Q): '),
    read_char(RowLetter),
    write('-> Enter Column (0-8): '),
    read_number(Column), 
    (
        validate_position(Board, Player, RowLetter, Row, Column) 
        ;
        write('Invalid position!\nPlease choose again:\n'), fail
    ), 
    (
        valid_moves_position(Board, Player, [Row, Column], Moves), 
        length(Moves, NMoves),
        NMoves > 0, !
        ;
        write('There are not any available moves for this piece! '), fail
    ), !.


/**
 * Reads a valid position that is empty
 */
read_empty_position(Board, Row, Column) :-
    repeat,
    write('-> Enter Row (A-Q): '),
    read_char(RowLetter),
    write('-> Enter Column (0-8): '),
    read_number(Column), 
    (
        letter(Row, RowLetter),
        validate_placing(Board, [Row, Column]) 
        ;
        write('Invalid position! Please choose an empty position!\n'), fail
    ), !.


/**
 * Reads a direction from input
 */
read_direction(Direction, PositionMoves, DirectionMoves) :-
    repeat,
    write('-> Enter Direction\n0 - NW\t1 - N\t2 - NE\t3 - SW\t4 - S\t5 - SE\nOption: '),
    read_number(Direction),
    (
        validate_direction(Direction, PositionMoves, DirectionMoves), !
        ;
        write('Invalid direction! Cannot move in that direction!\n'), fail
    ), !.


/**
 * Choose the stack divisions from the available ones
 */
read_substack_divisions(NStacks, Stacks, AvailableMoves) :-
    length(AvailableMoves, NMoves),
    NMoves < 9,
    repeat,
    write('-> Available divisions:\n'),
    print_list_with_index(AvailableMoves),
    write('Option: '),
    read_number(Option),
    (
        nth0(Option, AvailableMoves, Stacks), !
        ;
        write('Invalid Option!\n'), fail
    ), 
    length(Stacks, NStacks), !.


/**
 * Reads the number of substack divisions and reads them
 */
read_substack_divisions(NStacks, Stacks, AvailableMoves) :-
    repeat,
    write('-> Enter number of substack divisions: '),
    read_number(NStacks),
    NStacks > 1,
    read_stack_heights(NStacks, Stacks),
    (
        member(Stacks, AvailableMoves), !
        ;
        write('Invalid Division!\n'), fail
    ), !.


/**
 * Reads a move from input
 */
read_move(Board, Player, [NRow, NColumn, Direction, NStacks, Stacks]) :-
    write('========================================================================='), nl,
    write('                        Selecting a stack to move                        '), nl,
    write('-------------------------------------------------------------------------'), nl,
    read_position(Board, Player, NRow, NColumn, PositionMoves), !,
    read_direction(Direction, PositionMoves, DirectionMoves), !, 
    read_substack_divisions(NStacks, Stacks, DirectionMoves), !.


/**
 * Reads a placing from input
 */
read_placing(Board, [NRow, NColumn]) :-
    write('========================================================================='), nl,
    write('                        Selecting a cell to place                        '), nl,
    write('-------------------------------------------------------------------------'), nl,
    read_empty_position(Board, NRow, NColumn),
    write('========================================================================='), nl, nl, !.


/**
 * Checks if a position is valid or not
 */
validate_position(Board, Player, RowLetter, Row, Column) :-
    letter(Row, RowLetter), !,
    valid_position(Board, [Row, Column], Stack), !,
    get_player(Stack, Player), !.


/**
 * Checks if a direction is valid or not according to the available moves
 */
validate_direction(Direction, PositionMoves, DirectionMoves) :-
    direction(Direction, _, _), !,
    bagof(
        Stacks,
        Direction ^ NStacks ^ 
        (
            member([Direction, NStacks, Stacks], PositionMoves)
        ),
        DirectionMoves
    ),
    length(DirectionMoves, NMoves), !,
    NMoves > 0.


/**
 * Checks if a placing position is valid or not
 */
validate_placing(Board, Position) :-
    valid_position(Board, Position, Stack), !,
    Stack = 0.

