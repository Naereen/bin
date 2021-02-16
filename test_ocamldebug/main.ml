(** Test program for [OCamlDebug] *)

(** Print int, in decimal and print new line. *)
let print_int_endline (i : int) : unit =
  print_int i;
  print_newline();
;;

(** Print integers from 1 to [n], on separate lines. *)
let main (n : int) : unit =
  for i = 1 to n do
    print_int_endline i;
  done
;;

let _ = main 40 ;;


(** Now let's try something more complicated *)

type variable = string ;;
type formula =
  | Not of formula
  | Var of variable
  | And of formula * formula
  | Or of formula * formula
;;

let x = Var "x" and y = Var "y";;
let phi1 = Not x;;
let phi2 = Or(x, y);;
let phi3 = And(phi1, Not(phi2));;

let rec string_of_formula (phi : formula) : string =
  match phi with
  | Not phi -> "Not (" ^ (string_of_formula phi) ^ ")"
  | Var x -> x
  | And (phi1, phi2) -> "And (" ^ (string_of_formula phi1) ^ ", " ^ (string_of_formula phi2) ^ ")"
  | Or (phi1, phi2) -> "Or (" ^ (string_of_formula phi1) ^ ", " ^ (string_of_formula phi2) ^ ")"
;;

let _ =
  print_endline (string_of_formula x);
  print_endline (string_of_formula y);
  print_endline (string_of_formula phi1);
  print_endline (string_of_formula phi2);
  print_endline (string_of_formula phi3);
;;


(** First implementation, using function for valuations:
    easy and quick to write and efficient,
    but not great for debugging/introspection of the valuation...
*)
(* type valuation = variable -> bool;; *)
(* let value (v : valuation) (var : variable) = v var ;; *)

(** Second implementation, using association list for valuations:
    less elegent to write, and asymptotically could be less efficient,
    but better for debugging/introspection of the valuation!
*)
type valuation = (variable * bool) list;;

let value (v : valuation) (var : variable) =
  match List.assoc_opt var v with
  | Some b -> b
  | None -> false
;;

(* let val1 : valuation = function
  | "x" -> true
  | "y" -> false
  | _   -> false
;; *)
let val1 = [ ("x", true); ("y", false) ];;

(* let val2 : valuation = function
  | "x" -> false
  | "y" -> true
  | _   -> false
;; *)
let val2 = [ ("x", false); ("y", true) ];;

let rec eval (valu : valuation) (phi : formula) : bool =
  match phi with
  | Var x            -> value valu x
  | Not phi          -> not (eval valu phi)
  | And (phi1, phi2) -> (eval valu phi1) && (eval valu phi2)
  | Or (phi1, phi2)  -> (eval valu phi1) || (eval valu phi2)
;;

let _ =
  Printf.printf "\nFor valuation 1 :";
  Printf.printf "\n  %s = %s" (string_of_formula x) (string_of_bool (eval val1 x));
  Printf.printf "\n  %s = %s" (string_of_formula y) (string_of_bool (eval val1 y));
  Printf.printf "\n  %s = %s" (string_of_formula phi1) (string_of_bool (eval val1 phi1));
  Printf.printf "\n  %s = %s" (string_of_formula phi2) (string_of_bool (eval val1 phi2));
  Printf.printf "\n  %s = %s" (string_of_formula phi3) (string_of_bool (eval val1 phi3));
;;

let _ =
  Printf.printf "\nFor valuation 2 :";
  Printf.printf "\n  %s = %s" (string_of_formula x) (string_of_bool (eval val2 x));
  Printf.printf "\n  %s = %s" (string_of_formula y) (string_of_bool (eval val2 y));
  Printf.printf "\n  %s = %s" (string_of_formula phi1) (string_of_bool (eval val2 phi1));
  Printf.printf "\n  %s = %s" (string_of_formula phi2) (string_of_bool (eval val2 phi2));
  Printf.printf "\n  %s = %s" (string_of_formula phi3) (string_of_bool (eval val2 phi3));
;;
