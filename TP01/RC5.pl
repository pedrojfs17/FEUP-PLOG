homem(joao).

mulher(maria).
mulher(ana).

animal(cao).
animal(gato).
animal(tigre).

jogo(xadrez).
jogo(damas).

desporto(tenis).
desporto(natacao).

mora_em(ana, apartamento).
mora_em(joao, casa).
mora_em(maria, casa).

gosta_de(ana, cao).
gosta_de(ana, damas).
gosta_de(joao, xadrez).
gosta_de(joao, tenis).
gosta_de(maria, natacao).
gosta_de(maria, tenis).
gosta_de(maria, tigre).

% a) mora_em(X, apartamento), gosta_de(X, _Y), animal(_Y).

% b) mora_em(joao, casa), gosta_de(joao, _X), desporto(_X), mora_em(maria, casa), gosta_de(maria, _Y), desporto(_Y).

% c) gosta_de(X, _Y), gosta_de(X, _Z), desporto(_Y), jogo(_Z).

% d) mulher(_X), gosta_de(_X, tenis), gosta_de(X, tigre). 