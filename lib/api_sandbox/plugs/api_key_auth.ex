defmodule Plugs.ApiKeyAuth do
  import Plug.Conn
  alias ApiSandbox.AccountsGenerator
  def init(opts), do: opts

  def call(conn, _opts) do
    header_key = get_req_header(conn, "authorization") |> List.first()

    cond do
      is_nil(header_key) ->
        send_resp(conn, 403, "Missing API key")
        |> halt
      !String.contains?(header_key, "Basic ")->
        send_resp(conn, 403, "Wrong authentication attempt")
        |> halt
      validate_token(parse_header(header_key)) ->
        assign(conn, :accounts, AccountsGenerator.generate_data(parse_header(header_key)))
      true ->
        send_resp(conn, 403, "Invalid or disabled API key")
        |> halt
    end
  end

  def parse_header(str_basic) do
    str_basic
    |> String.replace_leading("Basic ", "")
    |> Base.decode64!()
  end

  def validate_token(token) do
    splitted_token = String.split(token, "_") # Valid token should include two underscores - random rule
    p1 = splitted_token |> Enum.at(0)
    p2 = splitted_token |> Enum.at(1)
    p3 = splitted_token |> Enum.at(2)
    length(splitted_token) == 3 && p1 == "test" && String.length(p2) > 5 && String.length(p2) < 15 && String.length(p3) > 2 && String.length(p3) < 8
  end
end
