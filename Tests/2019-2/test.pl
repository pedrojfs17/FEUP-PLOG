:- use_module(library(clpfd)).

/**
 * 5
 */
constroi_binarias(I, K, Vars, [Lbin | LBins]) :-
    I =< K, !,
    constroi_bins(I, Vars, LBin),
    I1 is I + 1,
    constroi_binarias(I1, K, Vars, LBins).

constroi_binarias(_, _, _, []).


constroi_bins(_, [], []).
constroi_bins(I, [Var | Vars], [LBin | LBins]) :-
    I #= Var #<=> LBin,
    constroi_bins(I, Vars, LBins).
