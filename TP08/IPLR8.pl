:- use_module(library(clpfd)).

/**
 * Preco em centimos
 */
mercearia :-
    Produtos = [Arroz, Batatas, Esparguete, Atum],

    domain(Produtos, 1, 1000),

    Arroz * Batatas * Esparguete * Atum #= 7110000,
    sum(Produtos, #=, 711),

    precoMultiplo(Produtos, 2),

    Batatas #> Atum, 
    Atum #> Arroz,
    Arroz #> Esparguete,

    labeling([], Produtos),
    write(Produtos),
    fail.


precoMultiplo([], 0).

precoMultiplo([Produto | Resto], N) :-
    (Produto mod 10 #= 0) #<=> B,
    N1 #= N - B,
    precoMultiplo(Resto, N1).

    

