membro(X, L) :- 
    L = [Y | L1], 
    X == Y.

membro(X, L) :- 
    L = [Y | L1], 
    membro(X, L1).

membro(X, L) :- append(_, [X | _], L).

last(L, X) :- append(_, [X | []], L).

membroN(1, [X | _], X).
membroN(N, [_ | T], X) :-
    N > 1,
    N1 is N - 1,
    membroN(N1, T, X).