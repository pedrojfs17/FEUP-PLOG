:- use_module(library(clpfd)).

houses(N, Houses, Time) :-
    length(Houses, N), % Ordem de visita às casas
    domain(Houses, 1, N),
    element(N, Houses, 6), % Acaba na casa 6
    all_distinct(Houses),
    times(Houses, Time),
    labeling([maximize(Time)], Houses).

times([_], 0).
times([H1, H2 | T], Time) :-
    Time #= Time2 + abs(H2 - H1),
    times([H2|T], Time2).
    
    

    
    