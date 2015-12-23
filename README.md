# Ocaml Chess AI System

This repository represents the AI system utilized in OCaml Chess. Please note that this code snippet was NOT designed to be run as a standalone project; this code is purely for demonstrative purposes. The entirety of OCaml Chess will be posted soon.

The AI system was researched and designed by Bomi Lee (creator of this repository), and written by Bomi Lee and Nate Rogalskyj.

## Overview
This AI system is based around the MinMax algorithm. The system constructs a move tree (Move_tree.ml), representing the string of possible moves that can be taken from a certain board state. In addition, each board state within the tree is assigned a float value representing the relative strength of each move.

The AI then performs the [MinMax algorithm](https://en.wikipedia.org/wiki/Minimax) (minmax.ml) on the move tree, in order to decide which move to pursue.

## Credits

Eval.ml and Position_score.ml were written by Bomi Lee
Move_tree.ml was written by Nate R
Minmax.ml was written by both Nate and Bomi
