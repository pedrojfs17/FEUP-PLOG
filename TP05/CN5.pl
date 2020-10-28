unificavel([],_,[]).

unificavel([T|Resto],T1,Resto1):-
    \+ T=T1, !,
    unificavel(Resto,T1,Resto1).

unificavel([T|Resto],T1,[T|Resto1]):- unificavel(Resto,T1,Resto1). 