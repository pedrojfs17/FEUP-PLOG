t(0+1, 1+0).
t(X+0+1, X+1+0). 
t(X+1+1, Z) :-
    t(X+1, X1),
    t(X1+1, Z). 

