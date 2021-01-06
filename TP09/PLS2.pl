:- use_module(library(clpfd)).

/**
 * Instrumentos
 * 1 - Harpa
 * 2 - Violino
 * 3 - Piano
 */
musicos :-
    Names = [Joao, Antonio, Francisco],
    domain(Names, 1, 3),
    all_distinct(Names),

    Antonio #\= 3, 
    Joao #\= 3,
    Joao #\= 2,

    labeling([], Names),
    write(Names), fail.
