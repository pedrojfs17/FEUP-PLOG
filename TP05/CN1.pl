A :- B, C, !, D, E.
A :- F, G. 

/*  If then else

    if (B, C)
        if (D, E) true
        else false
    else if (F, G) true
    else false

*/

ite(I, T, E) :- I, !, T.
ite(I, T, E) :- E.