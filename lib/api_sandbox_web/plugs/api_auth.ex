defmodule Plugs.ApiKeyAuth do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    key = get_req_header(conn, "authorization") |> List.first()
    IO.puts key
    # params_key = conn.params["token"]
    # key = params_key || (header_key && parse_header(header_key))


    # api_key =
    #   if key do
    #     MasterRepo.get_by(ApiKey, key: key) |> MasterRepo.preload(:company)
    #   end

    # case [key, api_key] do
    #   [nil, _] ->
    #     send_resp(conn, 400, "Missing API token key")
    #     |> halt

    #   [_, %ApiKey{}] ->
    #     assign(conn, :master_company, api_key.company)

    #   [_, _] ->
    #     send_resp(conn, 403, "Invalid or disabled API token key")
    #     |> halt
    # end
  end

  def parse_header(bearer_string) do
    String.replace_leading(bearer_string, "Bearer ", "")
  end
end
