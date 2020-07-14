defmodule ApiSandboxWeb.ApiController do
  use ApiSandboxWeb, :controller

  alias ApiSandbox.TransactionsGenerator

  def show_accounts(conn, _params) do
    accounts = conn.assigns[:accounts]
    conn
    |>put_status(200)
    |> json(accounts)
  end

  def show_account(conn, %{"account_id" => account_id}) do
    account = Enum.find(conn.assigns[:accounts], &(&1.id == account_id))

    if(!is_nil(account)) do
      conn
      |> put_status(200)
      |> json(account)
    else
      send_resp(conn, 404, "Not found")
      |> halt
    end
  end

  def show_transactions(conn, %{"account_id" => account_id}) do
    account = Enum.find(conn.assigns[:accounts], &(&1.id == account_id))
    transactions = get_transactions(account)
    if !is_nil(account) do
      conn
      |> put_status(200)
      |> json(transactions)
    else
      send_resp(conn, 404, "Not found")
      |> halt
    end
  end

  def show_transaction(conn, %{"account_id" => account_id, "transaction_id" => transaction_id}) do
    account = Enum.find(conn.assigns[:accounts], &(&1.id == account_id))
    transaction =
      if !is_nil(account) do
        account
        |> get_transactions()
        |> Enum.find(&(&1.id == transaction_id))
      end

    if !is_nil(transaction) do
      conn
      |> put_status(200)
      |> json(transaction)
    else
      send_resp(conn, 404, "Not found")
      |> halt
    end
  end

  def get_transactions(account_data) do
    if !is_nil(account_data) do
      running_balance = account_data.balances.available
      amount = Timex.day(Timex.today) * running_balance / 100000 |> Float.round(2) # gives "random" amount, changes daily
      TransactionsGenerator.generate_transaction(account_data.id, number_of_transactions(), running_balance, amount, Timex.today())
    end
  end

  def number_of_transactions() do
    date = ~D[2020-07-09] # fixed reference date
    Timex.diff(Timex.today(), date, :days) # Number of transactions to be generated will increase daily
  end
end
