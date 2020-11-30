/**
 * Write a separation line
 */
separator :- write('========================================================================='), nl.


/**
 * Clear the console
 */
clear :- write('\33\[2J').


/**
 * Press enter to continue
 */
pause :- write('Press enter to continue... '), skip_line.


/**
 *  Symbol of the player
 *  player_symbol/2
 *  player_symbol(Player, ?Symbol)
 *
 *  Player      Player Identifier
 *  Symbol      Symbol associated with the player
 */
player_symbol(p_empty, '   ').
player_symbol(p_yellow, 'Y').
player_symbol(p_red, 'R').
player_symbol(_, '   ').


/**
 *  Displays the game
 */
display_game([Reserve | [Board | []]], Player) :-
    print_column_numbers, nl,
    print_board(Board), nl,
    print_player_turn(Player, Reserve), nl, nl.


/**
 *  Print Column Numbers
 */
print_column_numbers :-
    write('       0   1   2   3   4   5   6   7   8'), !.


/**
 *  Displays the top line of the board board
 */
print_board(Board) :-
    NextRow is 0,
    SpaceLength is (4 * 5 + 2),
    print_spacing(SpaceLength), 
    print_line([]), nl,
    print_board(Board, 0, NextRow).

/**
 * Displays the bottom line of the board
 */
print_board([], _, _) :-
    print_spacing(21),
    write('\\'), 
    print_line([]),
    write('/'), nl.

/**
 * Displays lines with 5 cells in it
 */
print_board([Line | Rest], _, CurrentRow) :-
    letter(CurrentRow, RowSymbol),
    write(RowSymbol),
    NextRow is CurrentRow + 1,
    getSimplifiedLength('_', Line, Length),
    Length == 5,
    print_spacing(4),
    print_line_length5(Line), nl,
    print_board(Rest, 5, NextRow).

/**
 * Displays lines with a higher cell count than the previous one
 */
print_board([Line | Rest], PreviousLineLength, CurrentRow) :-
    NextRow is CurrentRow + 1,
    getSimplifiedLength('_', Line, Length),
    Length > PreviousLineLength,
    SpaceLength is (4 * abs(Length - 5) + 1),
    print_spacing(SpaceLength), 
    print_line(Line), nl,
    print_board(Rest, Length, NextRow).

/**
 * Display the other lines of the board
 */
print_board([Line | Rest], PreviousLineLength, CurrentRow) :-
    NextRow is CurrentRow + 1,
    getSimplifiedLength('_', Line, Length),
    Length < PreviousLineLength,
    SpaceLength is (4 * abs(Length - 5)),
    print_spacing(SpaceLength),
    write('\\'), 
    print_line(Line),
    write('/'), nl,
    print_board(Rest, Length, NextRow).


/**
 * Prints a line of the board
 */
print_line([]) :-
    write('___').

print_line([Cell | Rest]) :-
    Cell \= '_',
    write('___'),
    print_cell(Cell),
    print_line(Rest).

print_line([_ | Rest]) :-
    print_line(Rest).


/**
 * Prints a line with 5 cells of the board
 */
print_line_length5([Cell | []]) :-
    print_cell(Cell).

print_line_length5([Cell | Rest]) :-
    Cell \= '_',
    print_cell(Cell),
    write('___'),
    print_line_length5(Rest).

print_line_length5([_ | Rest]) :-
    print_line_length5(Rest).


/**
 *  Prints N white spaces
 *  print_spacing/1
 *  print_spacing(Length)
 *
 *  Length      Number of white spaces to print
 */
print_spacing(0) :- !.

print_spacing(Length) :-
    Length > 0, NewLength is Length - 1, write(' '), !,
    print_spacing(NewLength).


/**
 *  Prints the cell's content
 *  print_cell/1
 *  print_cell(Cell)
 *
 *  Cell        Cell to be displayed
 */
print_cell([]) :- !.

print_cell(0) :-
    write('/   \\').

print_cell(Stack) :-
    get_player(Stack, Player),
    player_symbol(Player, PlayerSymbol),
    write('/'), format('~w~|~`0t~d~2+', [PlayerSymbol, abs(Stack)]), write('\\').


/**
 *  Prints player turn information
 *  print_player_turn/1
 *  print_player_turn(Player, Reserve).
 */
print_player_turn(Player, _) :- \+player_symbol(Player, _), !.

print_player_turn(Player, Reserve) :-
    Reserve >= 0,
    Reserve < 10, !,
    player_symbol(Player, Symbol),

    write( ' /=============================\\                              /======\\  '), nl,
    format(' |        Player ~w Turn        |              Reserve Pieces  |   ~d  |  ', [Symbol, Reserve]), nl,
    write( ' \\=============================/                              \\======/  ').

print_player_turn(Player, Reserve) :-
    Reserve >= 10,
    player_symbol(Player, Symbol),

    write( ' /=============================\\                              /======\\  '), nl,
    format(' |        Player ~w Turn        |              Reserve Pieces  |  ~d  |  ', [Symbol, Reserve]), nl,
    write( ' \\=============================/                              \\======/  ').

