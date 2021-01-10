:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module('call_nth.pl').      /* Helper functions to get n solutions of the same predicate */

:- include('utils.pl').         /* Helper functions */
:- include('generate.pl').      /* Generate new puzzles */
:- include('problems.pl').      /* Example problems */
:- include('tests.pl').       /* Times of execution */
:- load_files('display.pl',[encoding('utf8')]).       /* Display functions */


/**
 * Direction
 * direction(+Direction, -OffsetX, -OffsetY)
 * 
 * w (West)
 * nw (North West) 
 * n (North) 
 * ne (North East)
 * e (East) 
 * se (South East) 
 * s (South) 
 * sw (South West) 
 * 
 */
direction(  w, -1,  0).
direction( nw, -1, -1).
direction(  n,  0, -1).
direction( ne,  1, -1).
direction(  e,  1,  0).
direction( se,  1,  1).
direction(  s,  0,  1).
direction( sw, -1,  1). 

menu :-
    repeat,
    display_main_menu,
    read_number(Option),
    choose_menu_option(Option).

display_main_menu :-
    separator,
    write('                White and Tan                '), nl,
    write('              Choose your option              '), nl,
    write('                1. Solve Puzzle                '), nl,
    write('                   0. Exit                   '), nl,
    separator.
/**
 * Main menu options
 * 0 - Exit
 * 1 - Solve Puzzle
 */
choose_menu_option(0).
choose_menu_option(1) :- solve_puzzle, !, fail.
choose_menu_option(_) :- write('               Invalid Option!'), nl, !, fail.

solve_puzzle :-
    separator,
    write('                 Solve Puzzle                    '), nl,
    write('   Consult problems.pl for list of problems   '), nl,
    write('                 0 - Exit                     '), nl,
    repeat,
    read_number(ProblemID),
    (
        ProblemID = 0
        ;
        (
            problem(ProblemID, Problem),
            solvePuzzle(Problem, Solution),
            write('Puzzle : '), write(Problem),nl,
            print_problem(Problem),
            write('1. Show Solution'),nl,
            write('0. Exit'),nl,
            repeat,
            read_number(Option),
            (
                Option = 0
                ;
                Option = 1,
                print_sol(Problem, Solution)
                ;
                write('Invalid Option!'), nl, !, fail
            )
            ;
            write('               Invalid Puzzle!'), nl, !, fail
        )
    ).

/**
 * Solve a puzzle using the best (according to our tests) heuristics
 */
solvePuzzle(Input, Solution) :- solvePuzzle(Input, Solution, ff, median, up).


/**
 * Solve puzzle. Returns the solution, given a matrix of NxN arrows with the directions
 */
solvePuzzle(Input, Solution, X, Y, Z) :-
    % Verify that input is a matrix NxN
    length(Input, N), 
    maplist(same_length(Input), Input),
    
    % Verify that input matrix is bigger than 3x3
    N > 3,

    % Creates a solution matrix the same size as the input
    length(Solution, N),
    maplist(same_length(Solution), Solution),

    % Build single lists instead of matrix to work with constraints
    append(Solution, Ls),
    append(Input, Directions),

    % Domain 0 or 1, 0 - white, 1 - tan
    domain(Ls, 0, 1),
    constrain(Ls, Solution, Directions), !,
    labeling([X, Y, Z], Ls), !.


/**
 * Set the constraints
 */
constrain(Arrows, Solution, Directions) :- constrain(Arrows, 0-0, Solution, Directions).

constrain([], _, _, []).

constrain([Arrow | RestArr], X-Y, Solution, [Direction | RestDir]) :-
    direction(Direction, OffsetX, OffsetY),
    direction_arrows(X-Y, Solution, OffsetX-OffsetY, DirArrows),
    global_cardinality(DirArrows, [0-N0, 1-N1]),
    ((Arrow #= 1 #/\ N1 #= 2) #\/ (Arrow #= 0 #/\ N0 #= 1)),
    nextPosition(X-Y, Solution, NextPosition),
    constrain(RestArr, NextPosition, Solution, RestDir), !.


/**
 * Get all the elements in a given direction starting from a given position
 */
direction_arrows(X-Y, Arrows, OffsetX-OffsetY, DirArrows) :-
    X1 is X + OffsetX,
    Y1 is Y + OffsetY,
    direction_arrows(X1-Y1, Arrows, OffsetX-OffsetY, [], DirArrows), !.

direction_arrows(X-Y, Arrows, OffsetX-OffsetY, Acc, DirArrows) :-
    X >= 0, Y >= 0,
    length(Arrows, L),
    X < L, Y < L,
    nth0(Y, Arrows, Row),
    nth0(X, Row, Arrow),
    append(Acc, [Arrow], NewAcc),
    X1 is X + OffsetX,
    Y1 is Y + OffsetY,
    direction_arrows(X1-Y1, Arrows, OffsetX-OffsetY, NewAcc, DirArrows), !.

direction_arrows(_, _, _, DirArrows, DirArrows) :- !.
