passaro(tweety).
peixe(goldie).
minhoca(molie).

gosta(X, Y) :- passaro(X), minhoca(Y).
gosta(X, Y) :- gato(X), peixe(Y).
gosta(X, Y) :- gato(X), passaro(Y).
gosta(X, Y) :- amigo(X, Y); amigo(Y, X).

gato(silvester).
pessoa(eu).

amigo(silvester, eu).

come(X, Y) :- gosta(X, Y), \+amigo(X, Y).

% a) come(silvester, Y).

% b) O gato come tudo o que gosta mas que nao é amigo.