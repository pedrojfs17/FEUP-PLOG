:- use_module(library(clpfd)).

zerozeros :-
    Fatores = [N1, N2],
    domain(Fatores, 1, 1000000000),

    N1 * N2 #= 1000000000,
    N1 #> N2,
    
    N1 #= F1 * 1000000000 + F2 * 100000000 + F3 * 10000000 + F4 * 1000000 + F5 * 100000 + F6 * 10000 + F7 * 1000 + F8 * 100 + F9 * 10 + F10,
    N2 #= G1 * 1000000000 + G2 * 100000000 + G3 * 10000000 + G4 * 1000000 + G5 * 100000 + G6 * 10000 + G7 * 1000 + G8 * 100 + G9 * 10 + G10,

    Num1 = [F1, F2, F3, F4, F5, F6, F7, F8, F9, F10],
    Num2 = [G1, G2, G3, G4, G5, G6, G7, G8, G9, G10],

    domain(Num1, 0, 9),
    domain(Num2, 0, 9),

    checkNon0Factors(Num1, 0),
    checkNon0Factors(Num2, 0),

    labeling([], Fatores),
    write(Fatores),
    fail.


checkNon0Factors([], _).

checkNon0Factors([Factor | Rest], 0) :-
    (Factor #> 0) #<=> B,
    checkNon0Factors(Rest, B).

checkNon0Factors([Factor | Rest], 1) :-
    Factor #> 0,
    checkNon0Factors(Rest, 1).

    