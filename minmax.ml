open Move_tree
open Chesstypes

let min_tuple (a_list: (float*move) list) : (float*move) =
  let x = List.sort (fun a b -> if (fst a = fst b) then 0 else if (fst a > fst b) then 1 else -1 ) a_list in
  List.hd x

let min (a_list: float list) : float =
  let x = List.sort (fun a b -> if (a = b) then 0 else if (a > b) then 1 else -1 ) a_list in
  List.hd x

let max (a_list: float list) : float =
  let x = List.sort (fun a b -> if (a = b) then 0 else if (a < b) then 1 else -1) a_list in
  List.hd x

let get_other_team (team:team) =
  match team with
  | Black -> White
  | White -> Black

let contain_leaf (tree_list: move_tree list) : bool =
  if tree_list = [] then true
  else (List.mem Leaf tree_list)

let rec get_min_max (tree:move_tree) (depth: int) (team:team) : float =
  match tree with
  | Node ((score, game, _) , tree_list)->
            if contain_leaf (tree_list) || (depth=0) then score else
            (match team with
                  |Black -> min (List.map (fun a -> get_min_max a (depth-1)  (get_other_team team)) tree_list)
                  |White-> max (List.map (fun b -> get_min_max b (depth-1) (get_other_team team)) tree_list))
  |Leaf -> failwith "Never reaches"

let minimax (tree:move_tree) (depth: int) (team: team) : (float * move) =
  match tree with
  |Node ((_, game, _) , tree_list) -> min_tuple (List.map (fun a ->
      match a with
            | Leaf -> failwith "There is no actual next layer"
            | Node ((_, _, move_opt) , _) ->
                      match move_opt with
                      | None -> failwith "There should be a move to get here"
                      | Some move ->  ((get_min_max a (depth-1) (get_other_team team)) , move)
       )
       tree_list )
  | Leaf -> failwith "There should be a top node"

let min_max (tree: move_tree) (levels: int) (team: team): (float * move option) =
  let x = minimax tree levels team in
  let (score, move) = x in
  (score, Some move)
