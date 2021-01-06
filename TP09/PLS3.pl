:- use_module(library(clpfd)).

/**
 * Items:
 * 1 - Livro
 * 2 - Vestido
 * 3 - Bolsa
 * 4 - Gravata
 * 5 - Chapeu
 * 6 - Candeeiro

 Sol = 1,2,3,4,5,6
 */
centroComercial :-
    Names = [Adams, Baker, Catt, Dodge, Ennis, Fisk],
    domain(Names, 1, 6),
    all_distinct(Names),

    Adams #= 1,
    Catt #\= 4, Catt #\= 2,
    Fisk #\= 4, Fisk #\= 2,
    Baker #\= 4, Catt #= 3,
    Ennis #= 5,


    labeling([], Names),
    write(Names), fail.
    