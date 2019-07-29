open Core

let assert_equal (input: string array) (result: string * string option) =
  assert (result = Rgb_to_hex.main input)

let assert_code (input: string array) (result: string) =
  let (code, _) = Rgb_to_hex.main input in
  assert (code = result)

let _ =
  let black = [|"0"; "0"; "0"|] in
  assert_equal black ("#000000", Some "Black");

