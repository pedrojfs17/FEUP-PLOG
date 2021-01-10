/**
 * Generates and solves a puzzle
 */
autoPuzzle(Puzzle, Solution, Size) :-
    generateSolution(Size, Solution),
    solvePuzzle(Puzzle, Solution), write(Puzzle), write(Solution), nl.


/**
 * Generates a valid solution
 */
generateSolution(Length, SolutionMatrix) :-
    length(SolutionMatrix, Length), 
    maplist(same_length(SolutionMatrix), SolutionMatrix),

    append(SolutionMatrix, SolutionList),
    domain(SolutionList, 0, 1),

    solutionConstrains(SolutionList, SolutionMatrix),

    labeling([], SolutionList).


/**
 * Apply solution restrictions
 */
solutionConstrains(SolutionList, SolutionMatrix) :- solutionConstrains(SolutionList, 0-0, SolutionMatrix).

solutionConstrains([], _, _).

solutionConstrains([Arrow | RestArr], X-Y, SolutionMatrix) :-
    applyRestrictionsDirections(Arrow, X-Y, SolutionMatrix),
    nextPosition(X-Y, SolutionMatrix, NextPosition),
    solutionConstrains(RestArr, NextPosition, SolutionMatrix).


/**
 * Apply restrictions to all the directions and ensures that at least one is true
 */
applyRestrictionsDirections(Arrow, X-Y, SolutionMatrix) :-
    getDirections(Directions),
    applyRestrictions(Directions, Arrow, X-Y, SolutionMatrix, Restrictions),
    Restrictions #> 0.


/**
 * Apply restrictions to all the directions
 */
applyRestrictions([], _, _, _, 0).

applyRestrictions([[_,OffsetX,OffsetY]|Rest], Arrow, X-Y, SolutionMatrix, N) :-
    direction_arrows(X-Y, SolutionMatrix, OffsetX-OffsetY, DirArrows),
    global_cardinality(DirArrows, [0-N0, 1-N1]),
    ((Arrow #= 1 #/\ N1 #= 2) #\/ (Arrow #= 0 #/\ N0 #= 1)) #<=> B,
    N #= M + B,
    applyRestrictions(Rest, Arrow, X-Y, SolutionMatrix, M).
