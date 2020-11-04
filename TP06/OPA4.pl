:- op(200,xfx,existe_em).

X existe_em [X|_].
X existe_em [_|L]:-
X existe_em L.


:- op(200,fx, concatena).
:- op(150, xfx, da).
:- op(100, xfx, e).

concatena [] e L da L.
concatena [X|L1] e L2 da [X|L3] :-
concatena L1 e L2 da L3.


:- op(200, fx, apaga).
:- op(100, xfx, a).

apaga X a [X|L] da L.
apaga X a [Y|L] da [Y|L1] :-
apaga X a L da L1. 