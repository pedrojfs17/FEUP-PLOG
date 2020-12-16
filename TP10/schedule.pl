:- use_module(library(clpfd)).

schedule(Ss, End) :-
    Ss = [S1,S2,S3,S4,S5,S6,S7],
    Es = [E1,E2,E3,E4,E5,E6,E7],
    Tasks = [
    task(S1, 16, E1, 2, 1),
    task(S2, 6, E2, 9, 2),
    task(S3, 13, E3, 3, 3),
    task(S4, 7, E4, 7, 4),
    task(S5, 5, E5, 10, 5),
    task(S6, 18, E6, 1, 6),
    task(S7, 4, E7, 11, 7)
    ],
    domain(Ss, 1, 30),
    maximum(End, Es),
    cumulative(Tasks, [limit(13)]),
    labeling([minimize(End)], Ss).
    