(* https://ocaml.org/learn/tutorials/performance_and_profiling.html *)
(* $ ocamlcp -p a graphics.cma graphtest.ml -o graphtest
   $ ./graphtest
   $ ocamlprof graphtest.ml
*)

let nbiter = 500

let () =
  Random.self_init ();
  Graphics.open_graph " 640x480"

let rec iterate r x_init i =
  if i == 1 then x_init
  else
    let x = iterate r x_init (i-1) in
    r *. x *. (1.0 -. x);;

let () =
  for x = 0 to 640 do
    let r = 4.0 *. (float_of_int x) /. 640.0 in
    for i = 0 to 39 do
      let x_init = Random.float 1.0 in
      let x_final = iterate r x_init nbiter in
      let y = int_of_float (x_final *. 480.) in
      Graphics.plot x y
    done
  done
