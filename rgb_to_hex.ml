open Core

let to_hex rgb_code =
  sprintf "%X" rgb_code

let preprocess s =
  let pattern = Str.regexp @@ Str.quote "," in
  Str.global_replace pattern "" s

let () =
  if Array.length Sys.argv <> 4 then exit 1;
  let args =
    Array.filteri Sys.argv ~f:(fun i _ -> i <> 0) |>
    Array.map ~f:(fun e -> int_of_string (preprocess e))
  in
  let result = Buffer.create 7 in
  Buffer.add_char result '#';
  Array.iter args ~f:(fun e -> Buffer.add_string result @@ to_hex e);
  print_endline @@ Buffer.contents result;

