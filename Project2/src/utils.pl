/**
 * Direction map
 */
direction_map(1, w).
direction_map(2, nw).
direction_map(3, n).
direction_map(4, ne).
direction_map(5, e).
direction_map(6, se).
direction_map(7, s).
direction_map(8, sw).


/**
 * Generates a matrix with directions from a matrix with integers
 */
map_directions([], []).
map_directions([Aux|RestAux], [Dir|RestDir]) :-
    direction_map(Aux, Dir),
    map_directions(RestAux, RestDir).


/**
 * Get the next position in Matrix
 */
nextPosition(X-Y, Matrix, 0-Y1) :-
    length(Matrix, N),
    N is X + 1,
    Y1 is Y + 1, !.

nextPosition(X-Y, _, X1-Y) :-
    X1 is X + 1, !.
  

/**
 * Get the irections and their offset
 */
getDirections(Directions) :-
    getDirections([], Directions), !.

getDirections(Acc, Directions) :-
    direction(Dir, OffsetX, OffsetY),
    \+member([Dir, OffsetX, OffsetY], Acc),
    append(Acc, [[Dir, OffsetX, OffsetY]], NewAcc),
    getDirections(NewAcc, Directions).

getDirections(Directions, Directions).
    

/**
 * Gets the NW-SE diagonal of a matrix
 */
diagonalNWtoSE([], []).
diagonalNWtoSE([[E|_]|Ess], [E|Ds]) :-
    maplist(list_tail, Ess, Ess0),
    diagonalNWtoSE(Ess0, Ds).


/**
 * Gets the NE-SW diagonal of a matrix
 */
diagonalNEtoSW(Ess,Ds) :-
    maplist(reverse, Ess, Fss),
    diagonalNWtoSE(Fss, Ds).


list_tail([_|Es], Es).

/**
 * Read entire line from input stream
 */
read_entire_line(Line) :-
    get_char(Ch),
    read_rest_line(Ch, Line).

read_rest_line(' ', []).
read_rest_line('\n', []).
read_rest_line(Ch, [Ch | Rest]) :-
    get_char(NewCh),
    read_rest_line(NewCh, Rest).

/**
 * Reads a number from input (0-9)
 */
read_number(Number) :-
    read_entire_line(Line),
    number_chars(Number, Line), !.
