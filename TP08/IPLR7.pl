:- use_module(library(clpfd)).

precoPeru(Preco) :-
    A in 1..9,
    B in 0..9,
    Preco * 72 #= A * 1000 + 670 + B.