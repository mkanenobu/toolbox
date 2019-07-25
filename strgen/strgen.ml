open Core

let parse_args args =
  int_of_string args.(1)

let () =
  let len = if Array.length Sys.argv > 1 then int_of_string (Sys.argv.(1)) else 8 in
  let result = Buffer.create 0 in
  Random.self_init ();
  for i = 0 to (len - 1) do
    let c = char_of_int (Random.int 100) in
    Buffer.add_char result c;
  done;
  print_endline @@ Buffer.contents result;
