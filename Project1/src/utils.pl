/**
 * Int to Char map
 */
letter(0, 'A').
letter(1, 'B').
letter(2, 'C').
letter(3, 'D').
letter(4, 'E').
letter(5, 'F').
letter(6, 'G').
letter(7, 'H').
letter(8, 'I').
letter(9, 'J').
letter(10, 'K').
letter(11, 'L').
letter(12, 'M').
letter(13, 'N').
letter(14, 'O').
letter(15, 'P').
letter(16, 'Q').


/**
 * Announce the winner
 */
announce(Winner) :-
    Winner = p_red,
    separator, nl,
    write('                              Red Player Won                             '), nl, nl,
    separator.

announce(_) :-
    separator, nl,
    write('                            Yellow Player Won                            '), nl, nl,
    separator.


/**
 * Get Length of Row excluding elements X
 */
getSimplifiedLength(X, List, Length) :-
    getSimplifiedLength(X, List, 0, Length), !.

getSimplifiedLength(_, [], Length, Length) :- !.

getSimplifiedLength(X, [X | Rest], Acc, Length) :- 
    getSimplifiedLength(X, Rest, Acc, Length), !.

getSimplifiedLength(X, [_ | Rest], Acc, Length) :- 
    NewAcc is Acc + 1,
    getSimplifiedLength(X, Rest, NewAcc, Length), !.


/**
 * Direction Map
 * North West - 0
 * North      - 1
 * North East - 2
 * South West - 3
 * South      - 4
 * South East - 5
 * direction(DirectionID, RowIncrement, ColumnIncrement)
 */
direction(0, -1, -1).
direction(1, -2, 0).
direction(2, -1, 1).
direction(3, 1, -1).
direction(4, 2, 0).
direction(5, 1, 1).

directions([[-1, -1], [-2, 0], [-1, 1], [1, -1], [2, 0], [1, 1]]).


/**
 * Get all integer partitions
 */
get_integer_partitions(Stack, Partitions) :-
    findall(Partition, integer_partition(Stack, Partition), Partitions).

integer_partition(Stack, Partition) :-
    sublist_of(Partition,[1,2,3,4,5,6,7,8]),
    sum(Partition, #=, Stack),
    length(Partition, Length),
    Length \= 1.
 

/**
 * Helper functions to get integer partitions
 */
sublist_of(Sub,List) :-
    list_sub(List,Sub).

list_sub([]    ,[]).
list_sub([_|Xs],Ys) :-
   list_sub(Xs,Ys).
list_sub([X|Xs],[X|Ys]) :-
   list_sub(Xs,Ys).



/**
 * Prints every element in the list in the format '<Index> - <Element>\t'
 */
print_list_with_index(List) :-
    print_list_with_index(0, List).

print_list_with_index(_, []) :- nl.

print_list_with_index(Index, [Item | Rest]) :-
    NewIndex is Index + 1,
    format('~d - ', [Index]),
    write(Item), write('\t'),
    print_list_with_index(NewIndex, Rest).


/**
 * Verifies if lists have common elements
 */
has_common_elements([], []) :- !.
has_common_elements(_, []) :- !.
has_common_elements([], _) :- !, fail.
has_common_elements([Top | _], List2) :-
    member(Top, List2).
has_common_elements([_ | Rest], List2) :-
    has_common_elements(Rest, List2), !.


/**
 * Helper function to add elements to construct a move
 */
addMovesToList(FinalList, _, [], FinalList).
addMovesToList(List, Position, [Move | Rest], FinalList) :-
    append(Position, Move, NewMove),
    append(List, [NewMove], NewList),
    addMovesToList(NewList, Position, Rest, FinalList).


/**
 * Transformation functions
 * Transforms a position in the hexagonal board into the column when that region is aligned horizontally
 * Regions:
 *  - 1: Left Right (LR) - Left side and Right side aligned horizontally
 *  - 2: UpperLeft BottomRight (ULBR) - Upper Left side and Bottom Right side aligned horizontally 
 *  - 3: UpperRight BottomLeft (URBL) - Upper Right side and Bottom Left side aligned horizontally 
 */
transform(1, [_, Column], Column) :- !.

transform(2, [Row, Column], TColumn) :-
  TColumn is (Row + Column - 4) / 2, !.

transform(3, [Row, Column], TColumn) :-
  TColumn is  (Row + (8-Column) - 4) / 2, !.


/**
 * Gets the max value from a list
 */
max_positive(List, MaxValue) :-
    max_positive(List, 0, MaxValue), !.

max_positive([], MaxValue, MaxValue) :- !.

max_positive([Current | Rest], CurrentMaxValue, MaxValue) :-
    (
        Current > CurrentMaxValue,
        max_positive(Rest, Current, MaxValue)
        ;
        max_positive(Rest, CurrentMaxValue, MaxValue)
    ), !.