/**
 * Main menu
 */
menu :-
    repeat,
    display_main_menu,
    read_number(Option),
    separator,
    choose_menu_option(Option).


/**
 * Main menu options
 * 0 - Exit
 * 1 - Player vs Player (pvp)
 * 2 - Player vs Computer (pvc)
 * 3 - Computer vs Computer (cvc)
 */
choose_menu_option(0).
choose_menu_option(1) :- display_pvp_title, playPvP, !, fail.
choose_menu_option(2) :- pvc_menu, nl, !, fail.
choose_menu_option(3) :- cvc_menu, nl, !, fail.
choose_menu_option(_) :- write('                             Invalid Option!'), nl, !, fail.


/**
 * Player vs Computer Menu
 * Chooses a difficulty and plays against a bot
 */
pvc_menu :-
    display_pvc_menu,
    readBotDifficulty(Bot),
    (
        Bot = 0
        ;
        display_pvc_title(Bot),
        playPvC(Bot)
    ).


/**
 * Computer vs Computer Menu
 * Chooses the difficulty of each bot and let them play against each other
 */
cvc_menu :-
    display_cvc_menu,
    readBotDifficulty(Bot1),
    (
        Bot1 = 0
        ;
        readBotDifficulty(Bot2),
        (
            Bot2 = 0
            ;
            display_cvc_title(Bot1-Bot2),
            playCvC(Bot1-Bot2)
        )
    ).


/**
 * Read a difficulty
 */
readBotDifficulty(Difficulty) :-
    repeat,
    display_difficulty_menu,
    read_number(Difficulty),
    separator,
    choose_difficulty_option(Difficulty).


/**
 * Bot difficulty options
 * 0 - Back
 * 1 - Easy (Random)
 * 2 - Hard (Greedy)
 */
choose_difficulty_option(0).
choose_difficulty_option(1).
choose_difficulty_option(2).
choose_difficulty_option(_) :- write('                             Invalid Option!'), nl, !, fail.


/**
 * Displays the main menu
 */
display_main_menu :-
    separator, nl,
    write('            ________.__         .__       .__                            '), nl,
    write('           /  _____/|  | _____  |__| _____|  |__   ___________           '), nl,
    write('          /   \\  ___|  | \\__  \\ |  |/  ___/  |  \\_/ __ \\_  __ \\    '), nl,
    write('          \\    \\_\\  \\  |__/ __ \\|  |\\___ \\|   Y  \\  ___/|  | \\/ '), nl,
    write('           \\______  /____(____  /__/____  >___|  /\\___  >__|           '), nl,
    write('                  \\/          \\/        \\/     \\/     \\/            '), nl, nl,
    write('                           1. Player vs Player                           '), nl,
    write('                          2. Player vs Computer                          '), nl,
    write('                         3. Computer vs Computer                         '), nl, nl,
    write('                                 0. Exit                                 '), nl,
    separator, write('                               Option: ').


/**
 * Displays Player vs Computer header
 */
display_pvc_menu :-
    nl, write('                            Player vs Computer                           '), nl, nl.


/**
 * Displays Computer vs Computer header
 */
display_cvc_menu :-
    nl, write('                           Computer vs Computer                          '), nl, nl.


/**
 * Displays menu to choose bot difficulty
 */
display_difficulty_menu :-
    write('                          Choose Bot Difficulty                          '), nl, nl,
    write('                                 1. Easy                                 '), nl,
    write('                                 2. Hard                                 '), nl, nl,
    write('                                 0. Back                                 '), nl,
    separator, write('                               Option: ').


/**
 * Displays Player vs Player title
 */
display_pvp_title :- separator, write('                             Player vs Player'), nl, separator.


/**
 * Displays Player vs Computer title
 */
display_pvc_title(1) :- separator, write('                                   Easy'), nl, separator.
display_pvc_title(2) :- separator, write('                                   Hard'), nl, separator.


/**
 * Displays Computer vs Computer title
 */
display_cvc_title(1-1) :- separator, write('                               Easy vs Easy'), nl, separator.
display_cvc_title(1-2) :- separator, write('                               Easy vs Hard'), nl, separator.
display_cvc_title(2-1) :- separator, write('                               Hard vs Easy'), nl, separator.
display_cvc_title(2-2) :- separator, write('                               Hard vs Hard'), nl, separator.