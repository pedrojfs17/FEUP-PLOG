:- use_module(library(clpfd)).

carros :-
    List = [A, B, C, D, 1, F, G, H, I, J, B, A],
    % Azul - 1, Amarelo - 2, Verde - 3, Vermelho - 4
    global_cardinality(List, [2-4, 3-2, 4-3, 1-3]),
    three_different(List),
    check_sequence(List, 1),
    labeling([], List),
    write(List).


/**
 * Every subsequence of three cars have 3 different colored cars
 */
three_different(List) :-
    length(List, L),
    L < 3.

three_different([A,B,C|T]) :-
    all_distinct([A,B,C]),
    three_different([B,C|T]).


/**
 * Checks if the sequence Yellow-Green-Red-Blue appears once
 */
check_sequence(List, 0):-
    length(List, L),
    L < 4.
    
check_sequence([A,B,C,D|T], Counter):-
    (A #= 2 #/\ B #= 3 #/\ C #= 4 #/\ D #= 1) #<=> Bin,
    Counter #= Counter1 + Bin,
    check_sequence([B,C,D|T],Counter1).

    
    
