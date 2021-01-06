:- use_module(library(clpfd)).

/**
 * 4
 */
gym_pairs(MenHeights, WomenHeights, Delta, Pairs) :-
    length(MenHeights, NPeople),
    length(Pairs, NPeople),

    % Each position refers to a men. The value refers to the index of the women
    length(Men, NPeople),
    domain(Men, 1, NPeople),
    all_distinct(Men),

    constraint(1, Men, MenHeights, WomenHeights, Delta),

    labeling([], Men),

    buildList(Men, 1, [], Pairs).


constraint(_, [], _, _, _).

constraint(N, [Men | Rest], MenHeights, WomenHeights, Delta) :-
    element(N, MenHeights, MenHeight),
    element(Men, WomenHeights, WomenHeight),
    MenHeight #>= WomenHeight,
    MenHeight #=< WomenHeight + Delta,
    N1 is N + 1,
    constraint(N1, Rest, MenHeights, WomenHeights, Delta).



buildList([], _, Pairs, Pairs).

buildList([Men | Rest], N, Acc, Pairs) :-
    Pair = N-Men,
    append(Acc, [Pair], NewAcc),
    N1 is N + 1,
    buildList(Rest, N1, NewAcc, Pairs).


/**
 * 5
 */
optimal_skating_pairs(MenHeights, WomenHeights, Delta, Pairs) :-
    length(MenHeights, NMens),
    length(WomenHeights, NWomens),

    NMens =< NWomens,

    length(Men, NMens),
    domain(Men, 1, NWomens),
    all_distinct(Men),

    constraintOptimal(1, Men, MenHeights, WomenHeights, Delta, [], Pairs), !,

    labeling([], Men).


optimal_skating_pairs(MenHeights, WomenHeights, Delta, Pairs) :-
    length(MenHeights, NMens),
    length(WomenHeights, NWomens),

    length(Women, NWomens),
    domain(Women, 1, NMens),
    all_distinct(Women),

    constraintOptimal1(1, Women, MenHeights, WomenHeights, Delta, [], Pairs), !,

    labeling([], Women).


constraintOptimal(_, [], _, _, _, Pairs, Pairs).

constraintOptimal(N, [Men | Rest], MenHeights, WomenHeights, Delta, Acc, Pairs) :-
    element(N, MenHeights, MenHeight),
    element(Men, WomenHeights, WomenHeight),
    (MenHeight #>= WomenHeight #/\ MenHeight #=< WomenHeight + Delta) #<=> B,
    (
        B = 1,
        append(Acc, [N-Men], NewAcc)
        ;
        true
    ),
    N1 is N + 1,
    constraintOptimal(N1, Rest, MenHeights, WomenHeights, Delta, NewAcc, Pairs).



constraintOptimal1(_, [], _, _, _, Pairs, Pairs).

constraintOptimal1(N, [Women | Rest], MenHeights, WomenHeights, Delta, Acc, Pairs) :-
    element(N, WomenHeights, WomenHeight),
    element(Women, MenHeights, MenHeight),
    (MenHeight #>= WomenHeight #/\ MenHeight #=< WomenHeight + Delta) #<=> B,
    (
        B = 1,
        append(Acc, [Women-N], NewAcc)
        ;
        true
    ),
    N1 is N + 1,
    constraintOptimal1(N1, Rest, MenHeights, WomenHeights, Delta, NewAcc, Pairs).




    