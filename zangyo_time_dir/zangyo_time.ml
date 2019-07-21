open Printf
open Api_request

let from_start_today (hour, minute) =
  hour * 3600 + minute * 60

let string_of_seconds seconds =
  let minutes = sprintf "%d minutes" @@ seconds mod 3600 / 60 in
  let hour = if abs seconds > 3600
    then sprintf "%d hour, " @@ seconds / 3600
    else "" in
  hour ^ minutes

let now =
  let now = Unix.localtime @@ Unix.time () in
  now.tm_hour, now.tm_min

let syukkin str =
  let pattern = "[0-9][0-9][0-9][0-9]" |> Str.regexp in
  if not (Str.string_match pattern str 0) then (
    printf "Invalid format\n";
    exit 2
  );
  let input = int_of_string str in
  input / 100, input mod 100

let working_seconds =
  9 * 3600


let () =
  if Array.length Sys.argv <= 1 then (
    printf "No argument\n";
    printf "COMMAND [4digits]\n";
    exit 1
  );
  (* TODO: APIで始業時間を取得 *)
  let syukkin_time = syukkin Sys.argv.(1) |> from_start_today in
  let now_time = now |> from_start_today in
  printf "%s\n" @@ string_of_seconds (now_time - syukkin_time - working_seconds)

