defmodule Plugs.ApiKeyAuth do
  import Plug.Conn
  alias ApiSandbox.AccountsGenerator
  alias ApiSandbox.TransactionsGenerator

  def init(opts), do: opts

  def call(conn, _opts) do
    header_key = get_req_header(conn, "authorization")

    api_key = header_key |> List.first |> parse_header
    
    case api_key do
      nil ->
        send_resp(conn, 400, "Missing API token key")
        |> halt

      api_key ->
        unless(String.length(api_key) < 10) do
          # conn = conn|> assign(:transactions, TransactionsGenerator.generate_transaction())
          # conn = conn|> assign(:transactions, []) 
          IO.puts("++++++++++++++++++++++++++++++++")
          conn |> assign(:accounts, AccountsGenerator.generate_data(conn, Base.decode64!(api_key))) 
          #todo validate token
        else
          send_resp(conn, 403, "Invalid or disabled API token key")
          |> halt
        end
    end
  end

  def parse_header(basic_string) do
    String.replace_leading(basic_string, "Basic ", "")
  end
end
