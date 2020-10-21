ligado(a,b). 
ligado(a,c). 
ligado(b,d). 
ligado(b,e). 
ligado(b,f). 
ligado(c,g). 
ligado(d,h). 
ligado(d,i). 
ligado(f,i).
ligado(f,j).
ligado(f,k).
ligado(g,l).
ligado(g,m).
ligado(k,n).
ligado(l,o).
ligado(i,f).

membro(X, [X|_]):- !.
membro(X, [_|Y]):- membro(X,Y).
concatena([], L, L).
concatena([X|Y], L, [X|Lista]):- concatena(Y, L, Lista).
inverte([X], [X]).
inverte([X|Y], Lista):- inverte(Y, Lista1), concatena(Lista1, [X], Lista). 

/* --------------------------------- */

resolva_prof(No_inicial, No_meta, Solucao) :-
    profundidade([], No_inicial, No_meta, Sol_inv),
    inverte(Sol_inv, Solucao). 

profundidade(Caminho, No_meta, No_meta, [No_meta|Caminho]).
profundidade(Caminho, No, No_meta, Sol) :-
    ligado(No, No1),
    \+membro(No1, Caminho),
    profundidade([No|Caminho], No1, No_meta, Sol).

/* --------------------------------- */

resolva_larg(No_inicial, No_meta, Solucao) :-
    largura([No_inicial], No_meta, Sol_inv),
    inverte(Sol_inv, Solucao). 

largura([[No_meta|T]|_], No_meta, [No_meta|T]).
largura([T|Fila], No_meta, Solucao):-
    ache_todos(ExtensaoAteFilho, estende_ate_filho(T, ExtensaoAteFilho), Extensoes),
    concatena(Fila, Extensoes, FilaExtendida),
    largura(FilaExtendida, No_meta, Solucao). 

ache_todos(X, Y, Z):- bagof(X, Y, Z), !.
ache_todos(_, _, []).

estende_ate_filho([N|Trajectoria], [N1,N|Trajectoria]):-
    ligado(N, N1),
    \+membro(N1, Trajectoria).
