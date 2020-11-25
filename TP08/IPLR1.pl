:- use_module(library(clpfd)).

magic3x3(Vars) :-
    Vars=[A,B,C,D,E,F,G,H,I],
    domain(Vars,1,9),
    Soma is (9+1)*3//2,
    all_distinct(Vars),
    A + B + C #= Soma,
    D + E + F #= Soma,
    G + H + I #= Soma,
    A + D + G #= Soma,
    B + E + H #= Soma,
    C + F + I #= Soma,
    A + E + I #= Soma,
    C + E + G #= Soma,
    A #< C, A #< G, C #< G,
    labeling([],Vars).
       
