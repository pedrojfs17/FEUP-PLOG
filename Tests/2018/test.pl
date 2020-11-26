%airport(Name, ICAO, Country)
airport('Aeroporto Francisco Sa Carneiro', 'LPPR', 'Portugal').
airport('Aeroporto Humberto Delgado', 'LPPT', 'Portugal').
airport('Aeropuerto Adolfo Suarez Madrid-Barajas', 'LEMD', 'Spain').
airport('Aeroport de Paris-Charles-de-Gaule Roissy Airport', 'LFPG', 'France').
airport('Aeroporto Internazionale di Roma-Fiumicino - Leonardo da Vinci', 'LIRF', 'Italy').

%company(ICAO, Name, Year, Contry)
company('TAP', 'TAP Air Portugal', 1945, 'Portugal').
company('RYR', 'Ryanair', 1984, 'Ireland').
company('AFR', 'Societe Air France', 1933, 'France').
company('BAW', 'British Airways', 1974, 'United Kingdom').

%flight(Designation, Origin, Destination, DepartureTime, Duration, Company)
flight('TP1923', 'LPPR', 'LPPT', 1115, 55, 'TAP').
flight('TP1968', 'LPPT', 'LPPR', 2235, 55, 'TAP').
flight('TP842', 'LPPT', 'LIRF', 1450, 195, 'TAP').
flight('TP843', 'LIRF', 'LPPT', 1935, 195, 'TAP').
flight('FR5483', 'LPPR', 'LEMD', 630, 105, 'RYR').
flight('FR5484', 'LEMD', 'LPPR', 1935, 105, 'RYR').
flight('AF1024', 'LFPG', 'LPPT', 940, 155, 'AFR').
flight('AF1025', 'LPPT', 'LFPG', 1310, 155, 'AFR').


/* 1 */
short(Flight) :-
    flight(Flight, _, _, _, Duration, _),
    Duration < 90.


/* 2 */
shorter(Flight1, Flight2, Flight1) :- 
    flight(Flight1, _, _, _, Duration1, _),
    flight(Flight2, _, _, _, Duration2, _),
    Duration1 < Duration2.

shorter(Flight1, Flight2, Flight2) :- 
    flight(Flight1, _, _, _, Duration1, _),
    flight(Flight2, _, _, _, Duration2, _),
    Duration2 < Duration1.


/* 3 */
arrivalTime(Flight, ArrivalTime) :-
    flight(Flight, _, _, DepartureTime, Duration, _),
    timeToMinutes(DepartureTime, DepartureTimeMinutes),
    ArrivalTimeMinutes is DepartureTimeMinutes + Duration,
    minutesToTime(ArrivalTimeMinutes, ArrivalTime).

timeToMinutes(Time, Minutes) :-
    Hours is div(Time, 100),
    Min is mod(Time, 100),
    Minutes is Hours * 60 + Min.

minutesToTime(Minutes, Time) :-
    Hours is mod(div(Minutes, 60), 24),
    Min is mod(Minutes, 60),
    Time is Hours * 100 + Min.


/* 4 */
memberOf(Element, [Element | _]).
memberOf(Element, [_| Rest]) :- memberOf(Element, Rest).

operates(Company, Country) :-
    company(Company, _, _, _),
    flight(_, ICAO, _, _, _, Company),
    airport(_, ICAO, Country).

operates(Company, Country) :-
    company(Company, _, _, _),
    flight(_, _, ICAO, _, _, Company),
    airport(_, ICAO, Country).

countries(Company, ListOfCountries) :-
    countries(Company, [], ListOfCountries), !.

countries(Company, Acc, ListOfCountries) :-
    operates(Company, Country),
    \+memberOf(Country, Acc),
    append(Acc, [Country], NewAcc),
    countries(Company, NewAcc, ListOfCountries).

countries(_, ListOfCountries, ListOfCountries).


/* 5 */
pairableFlights :-
    flight(Flight1, _, Airport, _, _, _),
    flight(Flight2, Airport, _, DepartureTime, _, _),
    arrivalTime(Flight1, ArrivalTime),
    timeToMinutes(ArrivalTime, ArrivalMin),
    timeToMinutes(DepartureTime, DepartureMin),
    Dif is DepartureMin - ArrivalMin,
    Dif >= 30, Dif =< 90,
    format('~s - ~s \\ ~s\n', [Airport, Flight1, Flight2]),
    fail.

pairableFlights.


/* 6 */
tripDays(Trip, Time, FlightTimes, Days) :-
    tripDays(Trip, Time, [], FlightTimes, 1, Days).

tripDays([_ | []], _, FlightTimes, FlightTimes, Days, Days).

tripDays([Country, Destination | Rest], Time, Acc, FlightTimes, DaysAcc, Days) :-
    flight(Flight, Origin, Destin, DepartureTime, _, _),
    airport(_, Origin, Country),
    airport(_, Destin, Destination),
    timeToMinutes(DepartureTime, DepartureMin),
    timeToMinutes(Time, TimeMin),
    (
        DepartureMin < TimeMin + 30,
        NewDaysAcc is DaysAcc + 1
        ;
        NewDaysAcc = DaysAcc
    ),
    arrivalTime(Flight, ArrivalTime),
    append(Acc, [DepartureTime], NewAcc),
    tripDays([Destination | Rest], ArrivalTime, NewAcc, FlightTimes, NewDaysAcc, Days).
