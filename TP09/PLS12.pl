:- use_module(library(clpfd)).

books :-
    Shelfs = [A, B, C, D, E, F, G, H],

    domain(Shelfs, 0, 100),

    A + C #= 27, B + D #= 25,
    C + D + G + H #= 34, D #= 3,
    A + E #= 23, C + G #= 23,
    F + H #= 20,
    E + F #= 31,

    labeling([], Shelfs),

    write(Shelfs), nl, 
    sum(Shelfs, #=, NBooks),
    write(NBooks).
    