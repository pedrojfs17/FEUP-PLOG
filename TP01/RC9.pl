aluno(joao, paradigmas).
aluno(maria, paradigmas).
aluno(joel, lab2).
aluno(joel, estruturas).

frequenta(joao, feup).
frequenta(maria, feup).
frequenta(joel, ist).

professor(carlos, paradigmas).
professor(ana_paula, estruturas).
professor(pedro, lab2).

funcionario(pedro, ist).
funcionario(ana_paula, feup).
funcionario(carlos, feup).

% a) aluno(Y, Z), professor(X, Z).
% b) frequenta(Y, X); funcionario(Y, X).
% c) aluno(X, Z), aluno(Y, Z), X@<Y; frequenta(X, W), frequenta(Y, W), X@<Y; funcionario(X, T), funcionario(Y, T), X@<Y.