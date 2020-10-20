ordenada([N]).

ordenada([N1,N2]):- N1 =< N2.

ordenada([N1,N2|Resto]):-
    N1 =< N2,
    ordenada([N2|Resto]). 

