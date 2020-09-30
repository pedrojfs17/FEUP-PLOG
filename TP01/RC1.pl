male('LJ Burrows').
male('Lincoln Burrows').
male('Michael Scofield').
male('Aldo Burrows').
female('Lisa Rix').
female('Christina Rose Scofield').
female('Sara Tancredi').
female('Ella Scofield').

parent('Lisa Rix', 'LJ Burrows').
parent('Lincoln Burrows', 'LJ Burrows').
parent('Sara Tancredi', 'Ella Scofield').
parent('Michael Scofield', 'Ella Scofield').
parent('Aldo Burrows', 'Lincoln Burrows').
parent('Christina Rose Scofield', 'Lincoln Burrows').
parent('Aldo Burrows', 'Michael Scofield').
parent('Christina Rose Scofield', 'Michael Scofield').

% a) parent(X, 'Michael Scofield').
% b) parent('Aldo Burrows', X).