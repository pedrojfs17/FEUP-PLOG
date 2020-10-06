comida(peru).
comida(frango).
comida(salmao).
comida(solha).

bebida(cerveja).
bebida('vinho verde').
bebida('vinho maduro').

pessoa(ana).
pessoa(antonio).
pessoa(barbara).
pessoa(bruno).

gosta(bruno, peru).
gosta(ana, peru).
gosta(antonio, frango).
gosta(barbara, salmao).

casado(ana, bruno).
casado(barbara, antonio).

combina(peru, cerveja).
combina(frango, cerveja).
combina(frango, 'vinho verde').
combina(solha, 'vinho maduro').
combina(salmao, 'vinho verde').

% a) casado(ana, bruno), gosta(ana, 'vinho verde'), gosta(bruno, 'vinho verde').

% b) combina(salmao, X).

% c) combina(X, 'vinho verde').