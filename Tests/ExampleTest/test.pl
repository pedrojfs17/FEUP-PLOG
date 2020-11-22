%participant(Id,Age,Performance)
participant(1234, 17, 'Pé coxinho').
participant(3423, 21, 'Programar com os pés').
participant(3788, 20, 'Sing a Bit').
participant(4865, 22, 'Pontes de esparguete').
participant(8937, 19, 'Pontes de pen-drives').
participant(2564, 20, 'Moodle hack').

%performance(Id,Times)
performance(1234,[120,120,120,120]).
performance(3423,[32,120,45,120]).
performance(3788,[110,2,6,43]).
performance(4865,[120,120,110,120]).
performance(8937,[97,101,105,110]).

/* 1 */
madeItThrough(Participant) :- 
    participant(Participant, _, _), 
    performance(Participant, Times),
    isMember(120, Times).

isMember(_, []) :- fail.
isMember(Element, [Element | _]).
isMember(Element, [_ | Rest]) :- isMember(Element, Rest).


/* 2 */
juriTimes(Participants, JuriMember, Times, Total) :-
    juriTimes(Participants, JuriMember, [], Times, 0, Total).

juriTimes([], _, Times, Times, Total, Total).
juriTimes([Participant | Rest], JuriMember, TimesAcc, Times, TotalAcc, Total) :-
    performance(Participant, PTimes),
    nth1Member(JuriMember, PTimes, JuriTime),
    NewTotalAcc is TotalAcc + JuriTime,
    append(TimesAcc, [JuriTime], NewTimesAcc),
    juriTimes(Rest, JuriMember, NewTimesAcc, Times, NewTotalAcc, Total).

nth1Member(1, [Element | _], Element).
nth1Member(_, [], _) :- fail.
nth1Member(Index, [_ | Rest], Element) :-
    NewIndex is Index - 1,
    nth1Member(NewIndex, Rest, Element).


/* 3 */
patientJuri(JuriMember) :-
    getParticipants(Participants),
    juriTimes(Participants, JuriMember, Times, _),
    isMember(120, Times),
    splitListByElement(120, Times, Rest),
    isMember(120, Rest).

getParticipants(Participants) :- getParticipants([], Participants).

getParticipants(Acc, Participants) :- 
    performance(Participant, _),
    \+isMember(Participant, Acc),
    append(Acc, [Participant], NewAcc),
    getParticipants(NewAcc, Participants).

getParticipants(Participants, Participants).

splitListByElement(Element, [Element | Rest], Rest).
splitListByElement(Element, [_ | List], Rest) :-
    splitListByElement(Element, List, Rest).


/* 4 */
bestParticipant(P1, P2, P1) :-
    performance(P1, Times1),
    performance(P2, Times2),
    sumOfTimes(Times1, Sum1),
    sumOfTimes(Times2, Sum2),
    Sum1 > Sum2.

bestParticipant(P1, P2, P2) :-
    performance(P1, Times1),
    performance(P2, Times2),
    sumOfTimes(Times1, Sum1),
    sumOfTimes(Times2, Sum2),
    Sum1 < Sum2.

sumOfTimes(Times, Total) :-
    sumOfTimes(Times, 0, Total).

sumOfTimes([], Total, Total).
sumOfTimes([Time | Rest], Acc, Total) :-
    NewAcc is Acc + Time,
    sumOfTimes(Rest, NewAcc, Total).


/* 5 */
allPerfs :-
    getParticipants(Participants),
    printPerformances(Participants).

printPerformances([]).
printPerformances([Participant | Rest]) :-
    participant(Participant, _, Act),
    performance(Participant, Times),
    format('~d:~s:', [Participant, Act]),
    write(Times), nl,
    printPerformances(Rest).


/* 6 */
nSuccessfulParticipants(T) :-
    findall(Participant, noButtonPressed(Participant), Participants),
    length(Participants, T).

noButtonPressed(Participant) :-
    performance(Participant, Times),
    findall(Time, (isMember(Time, Times), Time < 120), []).


/* 7 */
juriFans(JuriFansList) :- 
    findall(Participant, performance(Participant, _), Participants),
    juriFans(Participants, [], JuriFansList), !.

juriFans([], JuriFansList, JuriFansList).

juriFans([Participant | Rest], Acc, JuriFansList) :-
    jurisPassed(Participant, Juris),
    append(Acc, [Participant-Juris], NewAcc),
    juriFans(Rest, NewAcc, JuriFansList).

jurisPassed(Participant, Juris) :-
    performance(Participant, Times),
    jurisPassed(Times, 1, [], Juris).

jurisPassed([], _, Juris, Juris).

jurisPassed([120 | Rest], JuriMember, Acc, Juris) :-
    NextJuri is JuriMember + 1,
    append(Acc, [JuriMember], NewAcc),
    jurisPassed(Rest, NextJuri, NewAcc, Juris).

jurisPassed([_ | Rest], JuriMember, Acc, Juris) :-
    NextJuri is JuriMember + 1,
    jurisPassed(Rest, NextJuri, Acc, Juris).


/* 8 */
:- use_module(library(lists)).

firstNElements(N, List, SubList) :- append(SubList, _, List), length(SubList, N).

eligibleOutcome(Id,Perf,TT) :-
    performance(Id,Times),
    madeItThrough(Id),
    participant(Id,_,Perf),
    sumlist(Times,TT).

nextPhase(N, Participants) :-
    setof(TT-Id-Perf, eligibleOutcome(Id, Perf, TT), Eligible),
    reverse(Eligible, Sorted),
    firstNElements(N, Sorted, Participants).


/* 11 */
impoe(X,L) :-
    length(Mid,X),
    append(L1,[X|_],L), append(_,[X|Mid],L1).

langford(N, L) :-
    Length is 2 * N,
    length(L, Length),
    langford(N, L, Length).

langford(0, _, _).

langford(N, L, Length) :-
    impoe(N, L),
    N1 is N - 1,
    langford(N1, L, Length).