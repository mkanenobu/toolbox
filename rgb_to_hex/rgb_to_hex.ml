open Core
open Colors

let exit_with_message exit_code message =
  print_endline message;
  exit exit_code

let to_hex rgb_code =
  sprintf "%02X" rgb_code

let preprocess s =
  let comma = Str.regexp @@ Str.quote "," in
  let parenthetis_open = Str.regexp @@ Str.quote "(" in
  let parenthetis_end = Str.regexp @@ Str.quote ")" in
  let whitespace  = Str.regexp @@ Str.quote " " in
  let remove pattern = Str.global_replace pattern "" in
  s |> remove comma |> remove parenthetis_open |> remove parenthetis_end |> remove whitespace

let validate_args args =
  Array.iter args ~f:(fun arg ->
      if arg < 0 || arg > 255 then exit_with_message 2 "Value is out of range (0 <= n <= 255)"
    )

let () =
  if Array.length Sys.argv <> 4
  then exit_with_message 1 (sprintf "rgb-to-hex takes 3 args (%d args given)" @@ Array.length Sys.argv - 1);

  let args =
    try
      Array.filteri Sys.argv ~f:(fun i _ -> i <> 0) |>
      Array.map ~f:(fun e -> int_of_string (preprocess e))
    with _ -> exit_with_message 3 "Argument is not number"
  in
  validate_args args;

  let result = Buffer.create 7 in
  Buffer.add_char result '#';
  Array.iter args ~f:(fun e -> Buffer.add_string result @@ to_hex e);
  print_endline @@ Buffer.contents result;
  match Hashtbl.find color_names (Buffer.contents result) with
  | Some s -> print_endline s;
  | None -> ()

