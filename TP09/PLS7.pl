:- use_module(library(clpfd)).

/**
 * 1 - limonada
 * 2 - guaraná
 * 3 - whisky
 * 4 - vinho
 * 5 - champanhe
 * 6 - água
 * 7 - laranjada
 * 8 - café
 * 9 - chá
 * 10 - vermouth
 * 11 - cerveja
 * 12 - vodka
 */
bebidaFavorita :-
    Names = [Joao, Miguel, Nadia, Silvia, Afonso, Cristina, Geraldo, Julio, Maria, Maximo, Manuel, Ivone],
    domain(Names, 1, 12),
    all_distinct(Names),

    % 1 Ponto
    Geraldo #\= 12 #/\ Geraldo #\= 11 #/\ Geraldo #\= 10 #/\ Geraldo #\= 9 #/\ Geraldo #\= 8 #/\ Geraldo #\= 7,
    Julio #\= 12 #/\ Julio #\= 11 #/\ Julio #\= 10 #/\ Julio #\= 9 #/\ Julio #\= 8 #/\ Julio #\= 7, 
    Maria #\= 12 #/\ Maria #\= 11 #/\ Maria #\= 10 #/\ Maria #\= 9 #/\ Maria #\= 8 #/\ Maria #\= 7, 
    Maximo #\= 12 #/\ Maximo #\= 11 #/\ Maximo #\= 10 #/\ Maximo #\= 9 #/\ Maximo #\= 8 #/\ Maximo #\= 7, 
    Ivone #\= 12 #/\ Ivone #\= 11 #/\ Ivone #\= 10 #/\ Ivone #\= 9 #/\ Ivone #\= 8 #/\ Ivone #\= 7, 
    Manuel #\= 12 #/\ Manuel #\= 11 #/\ Manuel #\= 10 #/\ Manuel #\= 9 #/\ Manuel #\= 8 #/\ Manuel #\= 7, 

    % 2 Ponto
    Joao #\= 9 #/\ Joao #\= 8 #/\ Joao #\= 2 #/\ Joao #\= 3 #/\ Joao #\= 1 #/\ Joao #\= 7,
    Miguel #\= 9 #/\ Miguel #\= 8 #/\ Miguel #\= 2 #/\ Miguel #\= 3 #/\ Miguel #\= 1 #/\ Miguel #\= 7,
    Julio #\= 2 #/\ Julio #\= 3 #/\ Julio #\= 1,
    Geraldo #\= 2 #/\ Geraldo #\= 3 #/\ Geraldo #\= 1,
    Nadia #\= 9 #/\ Nadia #\= 8 #/\ Nadia #\= 2 #/\ Nadia #\= 3 #/\ Nadia #\= 1 #/\ Nadia #\= 7,
    Maria #\= 2 #/\ Maria #\= 3 #/\ Maria #\= 1,

    % 3 Ponto
    Geraldo #\= 6,
    Maximo #\= 6 #/\ Maximo #\= 3,
    Joao #\= 6 #/\ Joao #\= 12,
    Silvia #\= 6 #/\ Silvia #\= 3 #/\ Silvia #\= 9 #/\ Silvia #\= 12,

    % 4 Ponto
    Julio #\= 5 #/\ Julio #\= 6,
    Miguel #\= 5 #/\ Miguel #\= 6 #/\ Miguel #\= 12,
    Manuel #\= 2,
    Maximo #\= 2,
    Silvia #\= 8,
    Afonso #\= 8,

    labeling([], Names),
    write(Names), fail.
    
    
    
