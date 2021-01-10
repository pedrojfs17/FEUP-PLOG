/**
 * Write a separation line
 */
separator :- write('============================================='), nl.


/**
 * Clear the console
 */
clear :- write('\33\[2J').

/**
 * Empty arrows
 */
direction_empty(w, ' ⇦ ').
direction_empty(nw, ' ⬁ ').
direction_empty(n, ' ⇧ ').
direction_empty(ne, ' ⬀ ').
direction_empty(e, ' ⇨ ').
direction_empty(se, ' ⬂ ').
direction_empty(s, ' ⇩ ').
direction_empty(sw, ' ⬃ '). 


/**
 * Filled arrows
 */
direction_filled(w, ' ⬅ ').
direction_filled(nw, ' ⬉ ').
direction_filled(n, ' ⬆ ').
direction_filled(ne, ' ⬈ ').
direction_filled(e, ' ➞ ').
direction_filled(se, ' ⬊ ').
direction_filled(s, ' ⬇ ').
direction_filled(sw, ' ⬋ '). 


/**
 * Prints a problem and a solution
 */
print_ps(Problem, Solution) :-
    write('Problem:'), write(Problem), nl,
    print_problem(Problem),
    write('Solution:'), write(Solution), nl,
    print_solution(Problem, Solution), !.


/**
 * Prints a solution
 */
print_sol(Problem, Solution) :-
    write('Solution:'), write(Solution), nl,
    print_solution(Problem, Solution), !.


/**
 * Writes the problem and the solution only in text mode
 */
text_ps(Problem, Solution) :-
    write(Problem), write(Solution), !.


/**
 * Writes the solution only in text mode
 */
text_sol(Solution) :-
    write(Solution), !.


/**
 * Prins a problem
 */
print_problem([]).
print_problem([Row | Rest]) :-
    print_row(Row), nl,
    print_problem(Rest).


/**
 * Prints a solution
 */
print_solution([],[]).
print_solution([PRow | PRest],[SRow | SRest]) :-
    print_row(PRow, SRow), nl,
    print_solution(PRest, SRest).


/**
 * Prints a row with all empty arrows
 */
print_row([]).
print_row([Direction | Rest]) :-
    print_arrow(Direction, 0),
    print_row(Rest).


/**
 * Prints a row with arrows according to solution
 */
print_row([], []).
print_row([Direction | PRest], [Fill | SRest]) :-
    print_arrow(Direction, Fill),
    print_row(PRest, SRest).


/**
 * Prints an empty arrow
 */
print_arrow(Direction, 0) :-
    direction_empty(Direction, Symbol),
    write(Symbol).


/**
 * Prints a filled arrow
 */
print_arrow(Direction, 1) :-
    direction_filled(Direction, Symbol),
    write(Symbol).
