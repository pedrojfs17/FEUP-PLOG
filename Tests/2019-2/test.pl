:- use_module(library(clpfd)).
:- use_module(library(lists)).


/**
 * 5
 */
constroi_binarias(I, K, Vars, [LBin | LBins]) :-
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


buildMachines(_, [], Machines, Machines).
buildMachines(Id, [Size | Rest], Acc, Machines) :-
    append(Acc, [machine(Id, Size)], NewAcc),
    NewId is Id + 1,
    buildMachines(NewId, Rest, NewAcc, Machines).

buildTasks([], [], Items, Items).
buildTasks([SelectedMachine | RestMachines], [_-Size | Rest], Acc, Items) :-
    append(Acc, [task(0, 1, 1, Size, SelectedMachine)], NewAcc),
    buildTasks(RestMachines, Rest, NewAcc, Items).

prat(Prateleiras, Objetos, Vars) :-
    same_length(Vars, Objetos),

    append(Prateleiras, ListaPrateleiras),
    length(ListaPrateleiras, NPrateleiras),

    domain(Vars, 1, NPrateleiras),

    buildMachines(1, ListaPrateleiras, [], Machines),
    buildTasks(Vars, Objetos, [], Tasks),

    cumulatives(Tasks, Machines, [bound(upper)]),

    write(Tasks), nl, write(Machines),

    labeling([], Vars), write(Vars), nl, fail.


/**
 * 6
 * Prateleiras - [[Cap,Cap],[Cap,Cap]]
 * Objetos - [Peso-Volume,Peso-Volume,...]
 */
% prat(Prateleiras, Objetos, Vars) :-
%     length(Objetos, NObjetos),
%     length(Vars, NObjetos),

%     append(Prateleiras, ListaPrateleiras),
%     length(ListaPrateleiras, NPrateleiras),

%     % Get number of columns
%     nth0(0, Prateleiras, Row),
%     length(Row, NColumns),

%     domain(Vars, 1, NPrateleiras),

%     restricoes(Vars, Objetos, ListaPrateleiras, NColumns), !,
    
%     labeling([], Vars).


% restricoes(Vars, Objetos, Prateleiras, NCols) :-
%     length(Prateleiras, NPrat),
%     length(Acc, NPrat),
%     maplist(=(0), Acc),

%     totalCapUsado(Objetos, Vars, Acc, CapUsadas),
%     totalPesoUsado(Objetos, Vars, Acc, PesoUsado),

%     constraintVolume(CapUsadas, Prateleiras),
%     constraintPeso(1, PesoUsado, PesoUsado, NCols).


% /**
%  * Ensure that the volume used of each shelf is less than the shelf capacity
%  */
% constraintVolume([],[]).
% constraintVolume([Usado | RestUsado], [Prat | RestPrat]) :-
%     Usado #=< Prat,
%     constraintVolume(RestUsado, RestPrat).


% constraintPeso(_, [], _, _).
% constraintPeso(N, [Peso | Rest], CapPesUsada, NCols) :-
%     getDownShelf(N, CapPesUsada, NCols, PesoBaixo),
%     Peso #=< PesoBaixo,
%     N1 #= N + 1,
%     constraintPeso(N1, Rest, CapPesUsada, NCols).


% getDownShelf(N, CapPesUsada, NCols, Element) :-
%     length(CapPesUsada, NShelfs),
%     Elem is N + NCols,
%     (
%         Elem =< NShelfs,
%         element(Elem, CapPesUsada, Element)
%         ;
%         Element #= 1000000
%     ).


% /**
%  * Gets the total capacityused
%  */
% totalCapUsado([], [], CapUsada, CapUsada). 

% totalCapUsado([_-Volume | RestObjetos], [SelectedShelf | RestShelves], Acc, CapUsada) :-
%     element(SelectedShelf, Acc, OldCap),
%     NewCap #= OldCap + Volume,
%     copy_list_with_new_element(Acc, NewAcc, SelectedShelf, NewCap),
%     totalCapUsado(RestObjetos, RestShelves, NewAcc, CapUsada).

% totalPesoUsado([], [], PesoUsado, PesoUsado). 

% totalPesoUsado([Peso-_ | RestObjetos], [SelectedShelf | RestShelves], Acc, PesoUsado) :-
%     element(SelectedShelf, Acc, OldPeso),
%     NewPeso #= OldPeso + Peso,
%     copy_list_with_new_element(Acc, NewAcc, SelectedShelf, NewPeso),
%     totalPesoUsado(RestObjetos, RestShelves, NewAcc, PesoUsado).



% /**
%  * Copies list1 to list2 changing value in a given index
%  */
% copy_list_with_new_element([], [], _, _).

% copy_list_with_new_element([E1 | R1], [E2 | R2], Index, Value) :-
%     (Index #= 1 #/\ E2 #= Value) #\/ (Index #\= 1 #/\ E2 #= E1),
%     NewIndex #= Index - 1,
%     copy_list_with_new_element(R1, R2, NewIndex, Value).


/**
 * 8
 */
objeto(piano, 3, 30).
objeto(cadeira, 1, 10).
objeto(cama, 3, 15).
objeto(mesa, 2, 15).
homens(4).
tempo_max(60).


get_tasks([],[], [], _, Tasks,Tasks).
get_tasks([_-NH-DH | DT], [SH | ST], [EH | ET], Count, Accum, Tasks):-
	append(Accum, [task(SH, DH, EH, NH, Count)], NextAccum),
	NextCount is Count + 1,
	get_tasks(DT, ST, ET, NextCount, NextAccum, Tasks).
	

furniture :-
	homens(NumHomens),
	tempo_max(Tempo_max),
    findall(Objeto-NHomens-Duracao, objeto(Objeto, NHomens, Duracao), Objetos),
    
	length(Objetos, NumObjetos),
	length(StartTimes, NumObjetos),
    length(EndTimes, NumObjetos),
    
	domain(StartTimes, 0, Tempo_max),
    domain(EndTimes, 0, Tempo_max),
    
	maximum(Tempo, EndTimes),
    Tempo #=< Tempo_max,
    get_tasks(Objetos, StartTimes, EndTimes, 1, [], Tasks),
    
    cumulative(Tasks, [limit(NumHomens)]),
    
    append(StartTimes, EndTimes, Vars), !,
    
	labeling([minimize(Tempo)], Vars),
	write(Tempo), nl,
    write(StartTimes),
    write(EndTimes).


    

