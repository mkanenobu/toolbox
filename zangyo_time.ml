open Printf


let seconds_from_start_of_today (hour, minute) =
  hour * 3600 + minute * 60

let string_of_seconds seconds =
  if abs seconds < 3600 then
    sprintf "%d minutes" (seconds / 60)
  else
    sprintf "%d hours, %d minutes" (seconds / 3600) (seconds mod 3600 / 60)


let now =
  let now = Unix.localtime @@ Unix.time () in
  now.tm_hour, now.tm_min

(* TODO: APIで始業時間を取得 *)
let syukkin str =
  let pattern = Str.regexp "[0-9][0-9][0-9][0-9]" in
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
  let syukkin_time = seconds_from_start_of_today @@ syukkin Sys.argv.(1) in
  let now_time = seconds_from_start_of_today now in
  printf "%s\n" @@ string_of_seconds (now_time - syukkin_time - working_seconds)

