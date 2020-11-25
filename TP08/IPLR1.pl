:- use_module(library(clpfd)).

magic3x3 :-
    Vars=[A1,A2,A3,A4,A5,A6,A7,A8,A9],
    domain(Vars,1,9),
    Soma is (9+1)*3//2,
    all_distinct(Vars),
    A1 + A2 + A3 #= Soma,
    A4 + A5 + A6 #= Soma,
    A7 + A8 + A9 #= Soma,
    A1 + A4 + A7 #= Soma,
    A2 + A5 + A8 #= Soma,
    A3 + A6 + A9 #= Soma,
    A1 + A5 + A9 #= Soma,
    A3 + A5 + A7 #= Soma,
    A1 #< A3, A1 #< A7, A3 #< A7,
    labeling([],Vars).
       
