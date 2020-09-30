pilot(lamb).
pilot(besenyei).
pilot(chambliss).
pilot(macLean).
pilot(mangold).
pilot(jones).
pilot(bonhomme).

team(lamb, 'Breitling').
team(besenyei, 'Red Bull').
team(chambliss, 'Red Bull').
team(macLean, 'Mediterranean Racing Team').
team(mangold, 'Cobra').
team(jones, 'Matador').
team(bonhomme, 'Matador').

airplane(lamb, 'MX2').
airplane(besenyei, 'Edge540').
airplane(chambliss, 'Edge540').
airplane(macLean, 'Edge540').
airplane(mangold, 'Edge540').
airplane(jones, 'Edge540').
airplane(bonhomme, 'Edge540').

circuit(istambul).
circuit(budapest).
circuit(porto).

win(porto, jones).
win(istambul, mangold).
win(budapest, mangold).

gates(istambul, 9).
gates(budapest,6).
gates(porto,5).

teamWin(Team, Circuit) :- win(Circuit, X), team(X, Team).

% a) win(porto, X).
% b) teamWin(X, porto).
% c) win(Y,X), win(Z,X), Y\=Z.
% d) gates(X,Y), Y>8.
% e) airplane(X,Y), Y\='Edge540'.