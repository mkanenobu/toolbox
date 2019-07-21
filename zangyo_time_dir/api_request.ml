open Lwt
open Cohttp
open Cohttp_lwt_unix

let url = ""
let api_key = ""

exception No_api_key
exception No_url

let get url =
  Client.get (Uri.of_string url) >>= fun (resp, body) ->
  let status_code = resp |> Response.status |> Code.code_of_status in
  let res_body = body |> Cohttp_lwt.Body.to_string in
  res_body


let get_syukkin_time url api_key =
  if url = "" then raise No_url;
  if api_key = "" then raise No_api_key;
  Lwt_main.run @@ get @@ url ^ "?api_key=" ^ api_key

