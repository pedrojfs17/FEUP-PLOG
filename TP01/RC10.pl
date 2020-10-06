comprou(joao, honda).
comprou(joao, uno).
ano(honda, 1997). 
ano(uno, 1998).
valor(honda, 20000).
valor(uno, 7000).

pode_vender(Pessoa, Carro, Ano) :- comprou(Pessoa, Carro), valor(Carro, Y), Y @< 10000, ano(Carro, X), Ano-10 =< X, Ano >= X.
 