:- use_module(library(lists)).

functor2(Term, F, Arity) :- 
    length(Args, Arity),
    Term =.. [F | Args].

arg2(N, Term, Arg) :-
    Term =.. [Term | Args],
    nth1(N, Args, Arg).
    
