livro(maias).
tipo(maias, romance).
tipo(maias, ficcao).
autor('Eça de Queiroz').
nacionalidade('Eça de Queiroz', portugues).
nacionalidade('Eça de Queiroz', ingles).
escreveu('Eça de Queiroz', maias).

% a) escreveu(X, maias).

% b) autor(X), nacionalidade(X, portugues), escreveu(X, Y), tipo(Y, romance).

% c) autor(X), escreveu(X, Y), escreveu(X, Z), tipo(Y, ficcao), tipo(Z, T), T\=ficcao.

