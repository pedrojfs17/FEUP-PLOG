:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).

:- include('utils.pl').         /* Helper functions */
:- include('display.pl').       /* Game displaying functions */
:- include('board.pl').         /* Board functions */
:- include('input.pl').         /* User input functions */
:- include('game.pl').          /* Game logic functions */
:- include('menus.pl').         /* Menu functions */
:- include('ai.pl').            /* Bot functions */

/**
 *  Initial board
 */
initial([57, [
    [ '_', '_', '_', '_',   0, '_', '_', '_', '_'],
    [ '_', '_', '_',   0, '_',   6, '_', '_', '_'],
    [ '_', '_',   0, '_',   0, '_',   0, '_', '_'],
    [ '_',  -6, '_',   0, '_',   0, '_',   0, '_'],
    [   0, '_',   0, '_',   0, '_',   0, '_',   0],
    [ '_',   0, '_',   0, '_',   0, '_',   0, '_'],
    [   0, '_',   0, '_',   0, '_',   0, '_',  -6],
    [ '_',   0, '_',   0, '_',   0, '_',   0, '_'],
    [   0, '_',   0, '_',   0, '_',   0, '_',   0],
    [ '_',   0, '_',   0, '_',   0, '_',   0, '_'],
    [   6, '_',   0, '_',   0, '_',   0, '_',   0],
    [ '_',   0, '_',   0, '_',   0, '_',   0, '_'],
    [   0, '_',   0, '_',   0, '_',   0, '_',   0],
    [ '_',   0, '_',   0, '_',   0, '_',   6, '_'],
    [ '_', '_',   0, '_',   0, '_',   0, '_', '_'],
    [ '_', '_', '_',  -6, '_',   0, '_', '_', '_'],
    [ '_', '_', '_', '_',   0, '_', '_', '_', '_']
]]).

/**
 *  Intermediate board
 */
intermediate([30, [
    [ '_', '_', '_', '_',   0, '_', '_', '_', '_'],
    [ '_', '_', '_',   0, '_',   0, '_', '_', '_'],
    [ '_', '_',   0, '_',  -2, '_',   0, '_', '_'],
    [ '_',   0, '_',   4, '_',  -6, '_',   0, '_'],
    [   0, '_',   1, '_',  -1, '_',   0, '_',   1],
    [ '_',   5, '_',   2, '_',  -1, '_',   0, '_'],
    [   0, '_',   0, '_',   0, '_',   0, '_',   0],
    [ '_',   0, '_',  -1, '_',  -1, '_',   1, '_'],
    [   0, '_',  -2, '_',   0, '_',   6, '_',   1],
    [ '_',   0, '_',  -4, '_',  -2, '_',   0, '_'],
    [   0, '_',   0, '_',   0, '_',   0, '_',   0],
    [ '_',  -1, '_',   0, '_',  -1, '_',   0, '_'],
    [   0, '_',   1, '_',   0, '_',   0, '_',  -1],
    [ '_',   0, '_',   0, '_',   0, '_',   0, '_'],
    [ '_', '_',   0, '_',   0, '_',   0, '_', '_'],
    [ '_', '_', '_',   0, '_',   0, '_', '_', '_'],
    [ '_', '_', '_', '_',   0, '_', '_', '_', '_']
]]).

/**
 *  Final board - red won
 */
final([0, [
    [ '_', '_', '_', '_',  -1, '_', '_', '_', '_'],
    [ '_', '_', '_',   0, '_',   0, '_', '_', '_'],
    [ '_', '_',   0, '_',  -2, '_',   0, '_', '_'],
    [ '_',   1, '_',   4, '_',   0, '_',   0, '_'],
    [   0, '_',   1, '_',  -1, '_',   0, '_',   1],
    [ '_',   0, '_',   2, '_',  -2, '_',   0, '_'],
    [   0, '_',   0, '_',   0, '_',   0, '_',   0],
    [ '_',   0, '_',   3, '_',  -3, '_',   1, '_'],
    [   0, '_',  -2, '_',   3, '_',   6, '_',   1],
    [ '_',   0, '_',   0, '_',  -5, '_',   0, '_'],
    [   0, '_',   0, '_',  -1, '_',   0, '_',   0],
    [ '_',  -1, '_',   0, '_',  -1, '_',   0, '_'],
    [   0, '_',   1, '_',   0, '_',  -3, '_',  -1],
    [ '_',   0, '_',   0, '_',   0, '_',   0, '_'],
    [ '_', '_',   0, '_',   0, '_',  -1, '_', '_'],
    [ '_', '_', '_',   0, '_',   0, '_', '_', '_'],
    [ '_', '_', '_', '_',   0, '_', '_', '_', '_']
]]).


/**
 * Main routine
 */
play :- menu.


/**
 * Computer vs Computer
 */
playCvC(Bot1-Bot2) :-
    nl, initial(Board),
    display_game(Board, p_red),
    playCvC(Board, Bot1-Bot2, p_red, _).


playCvC([_, Board], _, Player, Result) :- 
    game_over(Board, Player, Result), !, announce(Result), pause.

playCvC([Reserve, Board], Bot1-Bot2, Player, Result) :-
    Reserve > 0,
    NewReserve is Reserve - 1,
    (
        Player = p_red,
        choose_move(Board, Player, Bot1, Move)
        ;
        choose_move(Board, Player, Bot2, Move)
    ),
    move(Board, Player, Move, NewBoard), !,
    (
        Player = p_red,
        choose_placing(NewBoard, Player, Bot1, Placing)
        ;
        choose_placing(NewBoard, Player, Bot2, Placing)
    ),
    place(NewBoard, Player, Placing, FinalTurnBoard),
    next_player(Player, NextPlayer),
    display_game([NewReserve, FinalTurnBoard], NextPlayer),
    !, playCvC([NewReserve, FinalTurnBoard], Bot1-Bot2, NextPlayer, Result).

playCvC([Reserve, Board], Bot1-Bot2, Player, Result) :-
    (
        Player = p_red,
        choose_move(Board, Player, Bot1, Move)
        ;
        choose_move(Board, Player, Bot2, Move)
    ),
    move(Board, Player, Move, FinalTurnBoard), !,
    next_player(Player, NextPlayer),
    display_game([Reserve, FinalTurnBoard], NextPlayer),
    !, playCvC([Reserve, FinalTurnBoard], Bot1-Bot2, NextPlayer, Result).


/**
 * Player vs Computer
 */
playPvC(Bot) :-
    nl, initial(Board),
    display_game(Board, p_red),
    playPvC(Board, Bot, p_red, _).


playPvC([_, Board], _, Player, Result) :- 
    game_over(Board, Player, Result), !, announce(Result), pause.
    
playPvC([Reserve, Board], Bot, Player, Result) :-
    Reserve > 0,
    NewReserve is Reserve - 1,
    (
        Player = p_red,
        read_move(Board, Player, Move)
        ;
        choose_move(Board, Player, Bot, Move)
    ),
    move(Board, Player, Move, NewBoard), !,
    display_game([Reserve, NewBoard], Player), !,
    (
        Player = p_red,
        read_placing(NewBoard, Placing)
        ;
        choose_placing(NewBoard, Player, Bot, Placing)
    ),
    place(NewBoard, Player, Placing, FinalTurnBoard),
    next_player(Player, NextPlayer),
    display_game([NewReserve, FinalTurnBoard], NextPlayer),
    !, playPvC([NewReserve, FinalTurnBoard], Bot, NextPlayer, Result).

playPvC([Reserve, Board], Bot, Player, Result) :-
    (
        Player = p_red,
        read_move(Board, Player, Move)
        ;
        choose_move(Board, Player, Bot, Move)
    ),
    move(Board, Player, Move, FinalTurnBoard), !,
    next_player(Player, NextPlayer),
    display_game([Reserve, FinalTurnBoard], NextPlayer),
    !, playPvC([Reserve, FinalTurnBoard], Bot, NextPlayer, Result).


/**
 * Player vs Player
 */
playPvP :-
    nl,
    initial(Board),
    display_game(Board, p_red),
    playPvP(Board, p_red, _).


playPvP([_, Board], Player, Result) :- 
    game_over(Board, Player, Result), !, announce(Result), pause.

playPvP([Reserve, Board], Player, Result) :-
    Reserve > 0,
    NewReserve is Reserve - 1,
    read_move(Board, Player, Move),
    move(Board, Player, Move, NewBoard), !,
    display_game([Reserve, NewBoard], Player), !,
    read_placing(NewBoard, Placing),
    place(NewBoard, Player, Placing, FinalTurnBoard),
    next_player(Player, NextPlayer),
    display_game([NewReserve, FinalTurnBoard], NextPlayer),
    !, playPvP([NewReserve, FinalTurnBoard], NextPlayer, Result).

playPvP([Reserve, Board], Player, Result) :-
    read_move(Board, Player, Move),
    move(Board, Player, Move, FinalTurnBoard), !,
    next_player(Player, NextPlayer),
    display_game([Reserve, FinalTurnBoard], NextPlayer),
    !, playPvP([Reserve, FinalTurnBoard], NextPlayer, Result).
