:- use_module(library(clpfd)).

/**
 * A - So Liquido
 * B - So Po
 * C - Dois
 * D - Nenhum
 */
liquidordust :-
    Vars = [A, B, C, D],
    domain(Vars, 0, 10000),

    sum(Vars, #=, Total),

    Total #= (A + D) * 3,
    2 * Total #= (B + D) * 7,
    C #= 427,
    Total #= D * 5,

    labeling([], Vars),

    write(Total), nl, write(Vars).
