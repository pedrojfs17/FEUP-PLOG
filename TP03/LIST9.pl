substitui(_, _, [], []).

substitui(X, Y, Lista1, Lista2) :-
    Lista1 = [H|LT],
    X == H,
    append([Y], L2, Lista2),
    substitui(X, Y, LT, L2).

substitui(X, Y, Lista1, Lista2) :-
    Lista1 = [H|LT],
    X \= H,
    append([H], L2, Lista2),
    substitui(X, Y, LT, L2).
