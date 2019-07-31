let shortener s =
  Str.first_chars s 1 ^
  (string_of_int @@ String.length s - 2) ^
  Str.last_chars s 1

let () =
  assert (shortener "localization" = "l10n");
  assert (shortener "internationalization" = "i18n");
  assert (shortener "kubernetes" = "k8s");
  let arg =
    try Sys.argv.(1)
    with _ -> exit 1
  in
  print_endline @@ shortener arg
