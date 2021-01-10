/**
 * The following options control the order in which the next variable is selected for assignment
 */
selection_order(leftmost).
selection_order(min).
selection_order(max).
selection_order(ff).
selection_order(anti_first_fail).
selection_order(occurrence).
selection_order(ffc).
selection_order(max_regret).

/**
 * The following options control the way in which choices are made for the selected variable X
 */
choices_way(step).
choices_way(enum).
choices_way(bisect).
choices_way(median).
choices_way(middle).

/**
 * The following options control the order in which the choices are made for the selected variable X
 */
choices_order(up).
choices_order(down).


/**
 * Save the heuristics tests to file heuristics.txt
 */
saveHeuristicsToFile :-
    open('heuristics.txt', write, S1),
    set_output(S1),
    testHeuristics,
    flush_output(S1),
    close(S1).


/**
 * Test all different heuristics combinations when solving problems
 */
testHeuristics:-
    selection_order(X),
    choices_way(Y),
    choices_order(Z),
    timeSolving(X,Y,Z),
    fail.

testHeuristics.


/**
 * Count the time that takes to solve all the problems with the best heuristic (according to our tests)
 */
timeSolving :- timeSolving(ff, median, up).

/**
 * Count the time that takes to solve all the problems with a given heuristics
 */
timeSolving(X,Y,Z) :-
    Pred =.. [solve, X, Y, Z],
    statistics(runtime, [T0|_]),
    (Pred ; true),
    statistics(runtime, [T1|_]),
    T is T1 - T0,
    format('~w, ~w, ~w : Took ~3d seconds\n', [X,Y,Z,T]), !.


/**
 * Solves all the problems with a given heuristics
 */
solve(X,Y,Z) :-
    problem(_, Problem),
    solvePuzzle(Problem, _, X, Y, Z),
    fail.


/**
 * Saves the N problems generating and time that it takes to a file
 */
saveGeneratingProblemsToFile(N) :-
    number_chars(N, X),
    atom_chars(Number, X),
    atom_concat('generating_', Number, Temp1),
    atom_concat(Temp1, '_problems.txt', FileName),

    open(FileName, write, S1),
    set_output(S1),
    
    % Save generating and solving provlems from 4x4 to 10x10
    saveGeneratingProblem(4,11,N),

    flush_output(S1),
    close(S1).
    

/**
 * Generates K problems of size NxN and saves the time
 */
saveGeneratingProblem(N, N, _).
saveGeneratingProblem(N, Max, K) :- 
    N < Max,
    format('~dx~d\n',[N,N]),
    statistics(runtime, [T0|_]),
    tryNTimes(K, N),
    statistics(runtime, [T1|_]),
    T is T1 - T0,
    format('Took ~3d sec.~n\n', [T]),
    N1 is N + 1,
    saveGeneratingProblem(N1, Max, K).


/**
 * Gets N Solutions of the predicate autoPuzzle
 */
tryNTimes(N, Size) :-
    findfirstn(N, U, autoPuzzle(_, U, Size), _).
    
findfirstn(N, Template, Goal_0, Instances) :-
   findall(Template, call_firstn(Goal_0, N), Instances).

call_firstn(Goal_0, N) :-
   N + N mod 1 >= 0, % ensures that N >=0 and N is an integer
   call_nth(Goal_0, Nth),
   ( Nth == N -> ! ; true ).
