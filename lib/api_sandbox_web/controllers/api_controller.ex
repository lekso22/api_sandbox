defmodule ApiSandboxWeb.ApiController do
  use ApiSandboxWeb, :controller

  alias ApiSandbox.TransactionsGenerator

  def index(conn, _params) do
  accounts = conn.assigns[:accounts]
  |> IO.inspect
  conn
  |>put_status(200)
  |> json(accounts)
  end

  def show(conn, %{"account_id" => account_id}) do
    account = List.first(conn.assigns[:accounts]) #todo get by id

    if(account.id == account_id) do  
      conn
      |> put_status(200)
      |> json(account)
    else
      send_resp(conn, 404, "Not found")
      |> halt
    end
  end

  def show_transactions(conn, %{"account_id" => account_id}) do
    account = List.first(conn.assigns[:accounts])
    |> IO.inspect
    if(account.id == account_id) do  
      # conn = update_conn(conn, account)
      transactions = conn.assigns[:transactions]
      conn
      |> put_status(200)
      |> json(transactions)
    else
      send_resp(conn, 404, "Not found")
      |> halt
    end
  end

  #todo update conn
  # def update_conn(conn, account)do
  #   transactions = conn.assigns[:transactions] || []
  #   transactions = TransactionsGenerator.generate_transaction(account, 3, 2000, 5)
  #   conn = conn|> assign(:transactions, transactions)
  # end
end