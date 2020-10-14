membro(X, L) :- append(_, [X | _], L).

delete_one(X, L, NL) :-
    append(L1, [X|L2], L),
    append(L1, L2, NL).

delete_all(X, L1, L2) :- 
    \+membro(X, L1), L2 = L1.

delete_all(X, L1, L2) :-
    delete_one(X, L1, LT),
    delete_all(X, LT, L2).

delete_all_list([X], L1, L2) :-
    delete_all(X, L1, L2).

delete_all_list(LX, L1, L2) :-
    LX = [X|LX1],
    delete_all(X, L1, LT),
    delete_all_list(LX1, LT, L2).