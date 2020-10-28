imaturo(X):- adulto(X), !, fail.
imaturo(X).

adulto(X):- pessoa(X), !, idade(X, N), N>=18.
adulto(X):- tartaruga(X), !, idade(X, N), N>=50. 

/*
O Cut em Imaturo funciona como no predicado Not. Se X for adulto então (!, fail)
não é imaturo. Senão é imaturo. É’ um Cut Vermelho pois é essencial para o
funcionamento do programa.
O Cut em adulto evita explorar espaço de pesquisa em que é impossível estar a
solução. Se X for uma pessoa, então só será adulto se tiver uma idade maior ou
igual a 18. Só se X não for uma pessoa é que se vai verificar se X é uma
Tartaruga, ...
É um Cut verde pois não altera as soluções obtidas mas sim a eficiência do
programa. 
*/