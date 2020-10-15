conta([], 0).

conta(Lista, N) :-
    N > 0,
    Lista = [_|L1],
    N1 is N - 1,
    conta(L1, N1).


conta_elem(_, [], 0).

conta_elem(X, Lista, N) :-
    N > 0,
    Lista = [Y|L1],
    X == Y,
    N1 is N - 1,
    conta_elem(X, L1, N1).
    
conta_elem(X, Lista, N) :-
    N > 0,
    Lista = [Y|L1],
    X \= Y,
    conta_elem(X, L1, N).
