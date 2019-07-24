open Core

let parse_args args =
  int_of_string args.(1)

let () =
  let result = Buffer.create 0 in
  for i = 0 to 100 do
    Buffer.add_char result 'a';
  done;
  print_endline @@ Buffer.contents result;
