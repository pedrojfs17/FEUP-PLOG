% a)

fatorial(0, 1).
fatorial(N, F) :- 
    N > 0,
    N1 is N-1, fatorial(N1, F1),
    F is N*F1.


% a) (melhor solução)

fact(N, F) :- fact(N, 1, F).
fact(0, F, F).
fact(N, Acc, F) :-
    N > 0,
    N1 is N-1,
    Acc1 is Acc * N,
    fact(N1, Acc1, F).


% b)

fibonacci(0, 1).
fibonacci(1, 1).
fibonacci(N, F) :-
    N > 1,
    N1 is N-1, fibonacci(N1, F1),
    N2 is N-2, fibonacci(N2, F2),
    F is F1+F2.
