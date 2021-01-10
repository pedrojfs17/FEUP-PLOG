# White and Tan

## **T3 White_and_Tan_2**


| Name                                     | Number    | E-Mail               |
| ---------------------------------------- | --------- | -------------------- |
| Pedro Jorge Fonseca Seixas               | 201806227 | up201806227@fe.up.pt |
| Telmo Alexandre Espirito Santo Baptista  | 201806554 | up201806554@fe.up.pt |

----
## **Installation and Execution**
There's no need for any configuration before running the game, apart from installing SICStus Prolog.
For this project it was used the 4.6.0 version of SICStus Prolog, if using a different version there's no confirmation the game will work properly.

The font used should be `MS Gothic` since it is the one that has the best Unicode character support.

To run in Windows using the graphic interface:
1. Open SICStus Prolog
2. Open `File` > `Consult` > `Select main.pl located in directory /src of this project`

If running via console:
1. Open SICStus Prolog
```prolog
:-prolog:set_current_directory('/full/path/to/project/directory').
consult('./src/main.pl').
```
or simply
```
consult('/full/path/to/project/src/main.pl').
```

In both cases, after loading the file, you can go to the main menu via running the command `menu`, like so:
```prolog
menu.
```

To generate puzzles the predicate `auto_puzzle` can be used, like so:
```prolog
autoPuzzle(-Puzzle, -Solution, +Size).
```
Where `Size` is the size of the matrix NxN, N being Size.