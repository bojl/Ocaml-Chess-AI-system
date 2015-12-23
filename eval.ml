(*
 * The value 'eval board move' returns an integer representing the strength
 * of the inputted move.
 *
 * MOVES are evaluated rather than BOARD STATE for the sake of efficiency
 *
 * Move evaluation is based off of the following:
 * I. Captured pieces - point value of captured piece
 * II. Piece positioning - net gain in positional advantage
 * III. Misc - misc, such as castled formation, piece is being moved, check,
 *        pawn moved to end, avoidance of check mate
 *
 * PRECONDITION: THE INPUTTED MOVE --MUST-- BE A VALID MOVE
 *)

open Chessmodel
open Position_score
open Chesstypes
open Display
open Rules

(* multipliers representing the weighting of the 3 board eval factors *)
let capture_mult = 1.0
let position_mult = 1.0
let misc_mult = 1.0

(* relative value of each piece; values derived from wikipedia *)
let get_piece_val (piece: piece): float =
  match piece.piecetype with
  | Pawn -> 100.
  | Knight -> 300.
  | Bishop -> 300.
  | Rook -> 500.
  | Queen -> 900.
  | King -> 1000000.

let get_piece (board: board) (loc: boardpos): piece option =
  snd !(get_square_on_board loc board)

(* points gathered from a piece capture *)
let capture_points (board: board) (move: move) : float =
  match move with
  | (_, _, dest) ->
    match get_piece board dest with
    | None -> 0.
    | Some piece -> get_piece_val piece

let position_points (board: board) (move: move) : float =
  match move with
  | (piece, src, dest) -> (get_pos_points piece dest true) +.
    (match get_piece board dest with
     | None -> 0.
     | Some cap_piece -> get_pos_points cap_piece dest true) -.
     get_pos_points piece src true

let rec get_moves_list (pieces: piece list) (game: game)
                       (acc: (move * movetype) list): (move * movetype) list =
  match pieces with
  | [] -> acc
  | h::t -> get_moves_list t game ((possible_movements h game) @ acc)

let misc_points (board: board) (move: move) : float = 0.

let eval (game: game) (move: move) : float =
  let team = (match move with
             | (a, _, _) -> a.team) in
  let team_mult = (match team with
                  | White -> 1.
                  | Black -> -1.) in
  let board = game.board in
  ((capture_mult *. (capture_points board move)) +.
  (position_mult *. (position_points board move)) +.
  (misc_mult *. (misc_points board move))) *. team_mult
