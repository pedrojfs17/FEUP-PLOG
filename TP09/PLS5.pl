:- use_module(library(clpfd)).

primeiro :-
    % 1 - Blue, 2 - Yellow, 3 - Green, 4 - Black
    Cor = [A, B, C, D],
    Tam = [E, F, G, H],
    domain(Cor, 1, 4),
    domain(Tam, 1, 4),
    all_distinct(Cor),
    all_distinct(Tam),

    % The green car is the smallest
    element(Green, Cor, 3), element(Green, Tam, 1),

    % The car imediatly before the blue is smaller than the imediatly after
    element(Blue, Cor, 1),
    BeforeBlue #= Blue - 1, AfterBlue #= Blue + 1,
    element(BeforeBlue, Tam, TamDepois), element(AfterBlue, Tam, TamAntes),
    TamAntes #< TamDepois,

    % Greeen car is after the bue car
    Green #< Blue,

    % Yellow car is after the black car
    element(Yellow, Cor, 2), element(Black, Cor, 4),
    Yellow #< Black,

    append(Cor, Tam, Vars),
    labeling([], Vars),
    write('Cores: '), write(Cor), nl,
    write('Tamanhos: '), write(Tam).








