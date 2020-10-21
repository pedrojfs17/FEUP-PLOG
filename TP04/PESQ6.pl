ligacao(1, 2).
ligacao(1, 3).
ligacao(2, 4).
ligacao(3, 4).
ligacao(3, 6).
ligacao(4, 6).
ligacao(5, 6).

ligado(X, Y) :- ligacao(X, Y); ligacao(Y, X).

caminho(NoInicio, NoFim, Lista):-
    caminho(NoInicio, NoFim, [NoInicio], Lista, 5).

caminho(NoInicio, NoFim, Lista, ListaFim, _):-
    ligado(NoInicio, NoFim),
    append(Lista, [NoFim], ListaFim).

caminho(NoInicio, NoFim, Lista, ListaFim, N):-
    N>0,
    ligado(NoInicio, NoInterm),
    NoInterm \= NoFim,
    \+(member(NoInterm, Lista)),
    append(Lista, [NoInterm], Lista2),
    N2 is N-1,
    caminho(NoInterm, NoFim, Lista2, ListaFim, N2). 
    
ciclos(No, Comp, Lista):-
    findall(Ciclo, caminho(No, No, [], Ciclo, Comp), Lista).
