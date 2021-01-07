:- use_module(library(clpfd)).
:- use_module(library(lists)).

/**
 * 4
 */
sweet_recipes(MaxTime, NEggs, RecipeTimes, RecipeEggs, Cookings, Eggs) :-
    length(RecipeTimes, NRecipes),

    Cookings = [R1, R2, R3],
    domain(Cookings, 1, NRecipes),
    all_distinct(Cookings),
    
    element(R1, RecipeTimes, T1),
    element(R2, RecipeTimes, T2),
    element(R3, RecipeTimes, T3),
    
    element(R1, RecipeEggs, E1),
    element(R2, RecipeEggs, E2),
    element(R3, RecipeEggs, E3),

    Eggs #= E1 + E2 + E3,
    TotalTime #= T1 + T2 + T3,

    TotalTime #=< MaxTime,
    Eggs #=< NEggs,

    labeling([maximize(Eggs)], Cookings).
    

/**
 * 5
 */
% cut(Shelves, Boards, SelectedBoards) :-
%     length(Shelves, NShelves),
%     length(Boards, NBoards),
%     length(SelectedBoards, NShelves),

%     domain(SelectedBoards, 1, NBoards),

%     getUsedBoards(Shelves, SelectedBoards, UsedBoards, NBoards),
%     constraintBoards(UsedBoards, Boards), 

%     labeling([], SelectedBoards).


% constraintBoards([], []).
% constraintBoards([UsedBoard | UsedRest], [Board | Rest]) :-
%     UsedBoard #=< Board,
%     constraintBoards(UsedRest, Rest).


% getUsedBoards(Shelves, SelectedBoards, UsedBoards, NBoards) :-
%     length(BoardsAcc, NBoards),
%     maplist(=(0), BoardsAcc),
%     getTotalUsed(Shelves, SelectedBoards, BoardsAcc, UsedBoards).


% getTotalUsed([], [], UsedBoards, UsedBoards).
% getTotalUsed([Shelf | RestShelves], [Selected | Rest], Acc, UsedBoards) :-
%     element(Selected, Acc, OldValue),
%     NewValue #= OldValue + Shelf,
%     copyListWithNewValue(Acc, NewAcc, Selected, NewValue),
%     getTotalUsed(RestShelves, Rest, NewAcc, UsedBoards).



% copyListWithNewValue([], [], _, _).
% copyListWithNewValue([E1 | L1], [E2 | L2], NewValueIndex, NewValue) :-
%     (NewValueIndex #= 1 #/\ E2 #= NewValue) #\/ (NewValueIndex #\= 1 #/\ E2 #= E1),
%     N1 #= NewValueIndex - 1,
%     copyListWithNewValue(L1, L2, N1, NewValue).


    
createMachines(_, [], Machines, Machines).
createMachines(Id, [Board | Rest], Acc, Machines) :-
    append(Acc, [machine(Id, Board)], NewAcc),
    NewId is Id + 1,
    createMachines(NewId, Rest, NewAcc, Machines).


createTasks([], [], Tasks, Tasks).
createTasks([Shelf | RestShelves], [Selected | Rest], Acc, Tasks) :-
    append(Acc, [task(0, 1, 1, Shelf, Selected)], NewAcc),
    createTasks(RestShelves, Rest, NewAcc, Tasks).


cut(Shelves, Boards, SelectedBoards) :-
    same_length(Shelves, SelectedBoards),
    length(Boards, NBoards),

    domain(SelectedBoards, 1, NBoards),
    
    createMachines(1, Boards, [], Machines),
    createTasks(Shelves, SelectedBoards, [], Tasks),
    cumulatives(Tasks, Machines, [bound(upper)]),

    labeling([], SelectedBoards).
    
    