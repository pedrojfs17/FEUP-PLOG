% :- use_module(library(lists)).

% p1(L1,L2) :-
%     gen(L1,L2),
%     test(L2).

% gen([],[]).
% gen(L1,[X|L2]) :-
%     select(X,L1,L3),
%     gen(L3,L2).

% test([]).
% test([_]).
% test([_,_]).
% test([X1,X2,X3|Xs]) :-
%     (X1 < X2, X2 < X3; X1 > X2, X2 > X3),
%     test(Xs).

% /**
%  * Ordena elementos 3 a 3 da lista L1 a comecar do inicio, crescente ou decrescente, e guarda em L2.
%  */

:- use_module(library(clpfd)).
:- use_module(library(lists)).

% p2(L1,L2) :-
%     length(L1,N),
%     length(L2,N),
%     %
%     pos(L1,L2,Is),
%     all_distinct(Is),
%     %
%     labeling([],Is),
%     test(L2).

% pos([],_,[]).
% pos([X|Xs],L2,[I|Is]) :-
%     nth1(I,L2,X),
%     pos(Xs,L2,Is).


% constroi(+NEmb,+Orcamento,+EmbPorObjeto,+CustoPorObjeto,-EmbUsadas,-Objetos)

% constroi(30,100,[6,4,12,20,6],[20,50,10,20,15],EmbUsadas,Objetos).
% EmbUsadas = 28,
% Objetos = [1,2,3,5]

% constroi(50,100,[6,4,12,20,6],[20,50,10,20,15],EmbUsadas,Objetos).
% EmbUsadas = 44,
% Objetos = [1,3,4,5]

constroi(NEmb,Orcamento,EmbPorObjeto,CustoPorObjeto,EmbUsadas,Objetos) :-
    length(EmbPorObjeto, NObjetos),

    Objetos = [O1, O2, O3, O4],
    domain(Objetos, 1, NObjetos),

    all_distinct(Objetos),

    element(O1, EmbPorObjeto, EO1),
    element(O1, CustoPorObjeto, CO1),
    
    element(O2, EmbPorObjeto, EO2),
    element(O2, CustoPorObjeto, CO2),
    
    element(O3, EmbPorObjeto, EO3),
    element(O3, CustoPorObjeto, CO3),
    
    element(O4, EmbPorObjeto, EO4),
    element(O4, CustoPorObjeto, CO4),

    EmbUsadas #= EO1 + EO2 + EO3 + EO4,
    CustoTotal #= CO1 + CO2 + CO3 + CO4,

    CustoTotal #=< Orcamento,
    EmbUsadas #=< NEmb,

    labeling([maximize(EmbUsadas)], Objetos).


% wrap([12,50,14,8,10,90,24], [100,45,70], S).
% S = [2,3,3,2,1,1,2] ? ;
% S = [3,3,2,3,1,1,2] ? ;
% no

wrap(Presents, PaperRolls, SelectedPaperRolls) :-
    length(Presents, NPresentes),
    length(SelectedPaperRolls, NPresentes),

    length(PaperRolls, NRolos),

    domain(SelectedPaperRolls, 1, NRolos),

    constraint(Presents, PaperRolls, SelectedPaperRolls, NRolos), !,

    labeling([], SelectedPaperRolls).


constraint(Presents, PaperRolls, SelectedPaperRolls, NRolos) :-
    % Initialize the roll accumulator with all 0
    length(AccRolos, NRolos),
    maplist(=(0), AccRolos),

    % Get total used
    totalUsado(Presents, SelectedPaperRolls, AccRolos, RolosUsados),

    % Constraint the totals
    constraint(RolosUsados, PaperRolls).


/**
 * Ensure that the paper used of each roll is less than the roll length
 */
constraint([],[]).
constraint([Usado | RestUsado], [Rolo | RestRolos]) :-
    Usado #=< Rolo,
    constraint(RestUsado, RestRolos).


/**
 * Gets the total paper used in the wrapping
 */
totalUsado([], [], RolosUsados, RolosUsados). 

totalUsado([Present | RestPresents], [SelectedPaperRoll | RestPaperRolls], Acc, RolosUsados) :-
    element(SelectedPaperRoll, Acc, OldValue),
    NewValue #= OldValue + Present,
    copy_list_with_new_element(Acc, NewAcc, SelectedPaperRoll, NewValue),
    totalUsado(RestPresents, RestPaperRolls, NewAcc, RolosUsados).


/**
 * Copies list1 to list2 changing value in a given index
 */
copy_list_with_new_element([], [], _, _).

copy_list_with_new_element([E1 | R1], [E2 | R2], Index, Value) :-
    (Index #= 1 #/\ E2 #= Value) #\/ (Index #\= 1 #/\ E2 #= E1),
    NewIndex #= Index - 1,
    copy_list_with_new_element(R1, R2, NewIndex, Value).


    

    




    


    


