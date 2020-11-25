%player(Name, UserName, Age).
player('Danny', 'Best Player Ever', 27).
player('Annie', 'Worst Player Ever', 24).
player('Harry', 'A-Star Player', 26).
player('Manny', 'The Player', 14).
player('Jonny', 'A Player', 16).

%game(Name, Categories, MinAge).
game('5 ATG', [action, adventure, open-world, multiplayer], 18).
game('Carrier Shift: Game Over', [action, fps, multiplayer, shooter], 16).
game('Duas Botas', [action, free, strategy, moba], 12).

:-dynamic played/4.

%played(Player, Game, HoursPlayed, PercentUnlocked)
played('Best Player Ever', '5 ATG', 3, 83).
played('Worst Player Ever', '5 ATG', 52, 9).
played('The Player', 'Carrier Shift: Game Over', 44, 22).
played('A Player', 'Carrier Shift: Game Over', 48, 24).
played('A-Star Player', 'Duas Botas', 37, 16).
played('Best Player Ever', 'Duas Botas', 33, 22).


/* 1 */
playedALot(Player) :-
    played(Player, _, Hours, _),
    Hours >= 50.


/* 2 */
isAgeAppropriate(Name, Game) :-
    player(Name, _, Age),
    game(Game, _, MinAge),
    Age >= MinAge.


/* 3 */
updatePlayer(Player, Game, Hours, Percentage) :-
    retract(played(Player, Game, PastH, PastP)),
    NewH is PastH + Hours,
    NewP is PastP + Percentage,
    assert(played(Player, Game, NewH, NewP)).


/* 4 */
memberOf(Element, [Element | _]).
memberOf(Element, [_ | Rest]) :- memberOf(Element, Rest).

listGamesOfCategory(Cat) :-
    game(Name, Categories, MinAge),
    memberOf(Cat, Categories),
    format('~s (~d)\n', [Name, MinAge]),
    fail.

listGamesOfCategory(_).


/* 5 */
timePlayingGames(Player, Games, ListOfTimes, SumTimes) :-
    timePlayingGames(Player, Games, [], ListOfTimes, 0, SumTimes).

timePlayingGames(_, [], ListOfTimes, ListOfTimes, SumTimes, SumTimes).
timePlayingGames(Player, [Game | Rest], TimesAcc, ListOfTimes, SumAcc, SumTimes) :-
    (
        played(Player, Game, Hours, _)
        ;
        Hours = 0
    ),
    append(TimesAcc, [Hours], NewTimesAcc),
    NewSumAcc is SumAcc + Hours,
    timePlayingGames(Player, Rest, NewTimesAcc, ListOfTimes, NewSumAcc, SumTimes).


/* 6 */
getGames(Games) :-
    getGames([], Games).

getGames(Acc, Games) :-
    game(Game, _, _),
    \+memberOf(Game, Acc),
    append(Acc, [Game], NewAcc),
    getGames(NewAcc, Games).
getGames(Games, Games).

fewHours(Player, Games) :-
    getGames(AllGames),
    fewHours(Player, AllGames, [], Games), !.

fewHours(_, [], Games, Games) :- !.

% If the player has played the game
fewHours(Player, [Game | Rest], Acc, Games) :-
    played(Player, Game, Hours, _),
    (
        Hours < 10,
        append(Acc, [Game], NewAcc)
        ;
        NewAcc = Acc
    ),
    fewHours(Player, Rest, NewAcc, Games).

% If the player has not played the game yet
fewHours(Player, [_ | Rest], Acc, Games) :-
    fewHours(Player, Rest, Acc, Games).


/* 7 */
ageRange(MinAge, MaxAge, Players) :-
    findall(
        Player, 
        (
            player(Player, _, Age),
            Age >= MinAge,
            Age =< MaxAge    
        ), 
        Players
    ).


/* 8 */
sumList(List, Sum) :-
    sumList(List, 0, Sum).

sumList([], Sum, Sum).
sumList([Element | Rest], Acc, Sum) :-
    NewAcc is Acc + Element,
    sumList(Rest, NewAcc, Sum).

averageAge(Game, AverageAge) :-
    findall(Age, (player(_, Username, Age), played(Username, Game, _, _)), PlayersAge),
    sumList(PlayersAge, Sum),
    length(PlayersAge, NPlayers),
    AverageAge is Sum / NPlayers.


/* 9 */
:- use_module(library(lists)).

mostEffectivePlayers(Game, Players) :-
    findall(
        Efficiency-Player,
        (
            played(Player, Game, Hours, Percentage),
            Efficiency is Percentage / Hours
        ), 
        PlayersEfficiency
    ),
    sort(PlayersEfficiency, Sorted),
    reverse(Sorted, FinalList),
    getMostEffective(FinalList, Players), !.

getMostEffective([BestEfficiency-BestPlayer | Rest], Players) :-
    getMostEffective(Rest, BestEfficiency, [BestPlayer], Players).

getMostEffective([Player | Rest], BestEfficiency, BestList, Players) :-
    Player = BestEfficiency-P,
    append(BestList, [P], NewBestList),
    getMostEffective(Rest, BestEfficiency, NewBestList, Players).

getMostEffective(_, _, Players, Players).


/* 10 */
/*

    O predicado tem o proposito de verificar se um jogador apenas jogou jogos para os quais tem
    idade para jogar.

    O cut e um cut verde pois apenas serve para evitar backtracking desnecessario, viste que, ao
    falhar, quer dizer que encontrou um jogo para o qual o jogador nao teria idade para jogar, e,
    por isso, nao e necessario verificar mais jogos pois o predicado falha

    O X e um argumento que deve ser dado, para verificar se o jogador X apenas jogou jogos permitidos
    para a sua idade

    Nomes alternativos:
    X - Player
    Y - _Name
    Z - Age
    G - Game
    L - _Hours
    M - _Percent
    N - _Cat
    W - MinAge
*/

    