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



armario([[20,30,6,50],[50,75,15,125],[60,90,18,150],[30,45,9,75],[40,60,12,100]]).
objetos([114-54,305-30,295-53,376-39,468-84,114-48,337-11,259-80,473-28,386-55,258-39,391-37,365-76,251-18,144-42,399-94,463-48,473-9,132-56,367-8]).

test2(Vars) :-
    armario(A),
    objetos(Objs),
    prat(A, Objs, Vars).

test(Vars) :- prat([[30,6],[75,15]],[176-40,396-24,474-35,250-8,149-5,479-5], Vars).

/**
 * 6
 * Prateleiras - [[Cap,Cap],[Cap,Cap]]
 * Objetos - [Peso-Volume,Peso-Volume,...]
 */
prat(Prateleiras, Objetos, Vars) :-
    length(Objetos, NObjetos),
    length(Vars, NObjetos),

    append(Prateleiras, ListaPrateleiras),
    length(ListaPrateleiras, NPrateleiras),

    % Get number of columns
    nth0(0, Prateleiras, Row),
    length(Row, NColumns),

    domain(Vars, 1, NPrateleiras),

    restricoes(Vars, Objetos, ListaPrateleiras, NColumns), !,
    
    labeling([], Vars).


restricoes(Vars, Objetos, Prateleiras, NCols) :-
    length(Prateleiras, NPrat),
    length(Acc, NPrat),
    maplist(=(0), Acc),

    totalCapUsado(Objetos, Vars, Acc, CapUsadas),
    totalPesoUsado(Objetos, Vars, Acc, PesoUsado),

    constraintVolume(CapUsadas, Prateleiras),
    constraintPeso(1, PesoUsado, PesoUsado, NCols).


/**
 * Ensure that the volume used of each shelf is less than the shelf capacity
 */
constraintVolume([],[]).
constraintVolume([Usado | RestUsado], [Prat | RestPrat]) :-
    Usado #=< Prat,
    constraintVolume(RestUsado, RestPrat).


constraintPeso(_, [], _, _).
constraintPeso(N, [Peso | Rest], CapPesUsada, NCols) :-
    getDownShelf(N, CapPesUsada, NCols, PesoBaixo),
    Peso #=< PesoBaixo,
    N1 #= N + 1,
    constraintPeso(N1, Rest, CapPesUsada, NCols).


getDownShelf(N, CapPesUsada, NCols, Element) :-
    length(CapPesUsada, NShelfs),
    Elem is N + NCols,
    (
        Elem =< NShelfs,
        element(Elem, CapPesUsada, Element)
        ;
        Element #= 1000000
    ).


/**
 * Gets the total capacityused
 */
totalCapUsado([], [], CapUsada, CapUsada). 

totalCapUsado([_-Volume | RestObjetos], [SelectedShelf | RestShelves], Acc, CapUsada) :-
    element(SelectedShelf, Acc, OldCap),
    NewCap #= OldCap + Volume,
    copy_list_with_new_element(Acc, NewAcc, SelectedShelf, NewCap),
    totalCapUsado(RestObjetos, RestShelves, NewAcc, CapUsada).

totalPesoUsado([], [], PesoUsado, PesoUsado). 

totalPesoUsado([Peso-_ | RestObjetos], [SelectedShelf | RestShelves], Acc, PesoUsado) :-
    element(SelectedShelf, Acc, OldPeso),
    NewPeso #= OldPeso + Peso,
    copy_list_with_new_element(Acc, NewAcc, SelectedShelf, NewPeso),
    totalPesoUsado(RestObjetos, RestShelves, NewAcc, PesoUsado).



/**
 * Copies list1 to list2 changing value in a given index
 */
copy_list_with_new_element([], [], _, _).

copy_list_with_new_element([E1 | R1], [E2 | R2], Index, Value) :-
    (Index #= 1 #/\ E2 #= Value) #\/ (Index #\= 1 #/\ E2 #= E1),
    NewIndex #= Index - 1,
    copy_list_with_new_element(R1, R2, NewIndex, Value).


    

