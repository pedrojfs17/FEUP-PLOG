:- use_module(library(clpfd)).

precoPeru(Preco) :-
    A in 1..9,
    B in 0..9,
    Total #= A*1000 + 670 + B,
    Resto #= Total mod 72,
    Resto #= 0,
    Preco is (1000 * A + 670 + B) / 72.