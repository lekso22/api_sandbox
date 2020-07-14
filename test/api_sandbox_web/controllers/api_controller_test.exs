defmodule ApiSandboxWeb.ApiControllerTest do
  use ApiSandboxWeb.ConnCase

  test "GET accounts gives a list of accounts", %{conn: conn} do
    conn =
      conn
      |> put_req_header("authorization", "Basic dGVzdF9CRERCZkJMUVFHSGNfZ1dhc2Q6")
      |> get(Routes.api_path(conn, :show_accounts))
    accounts = json_response(conn, 200)

    assert conn.status == 200
    assert is_list(accounts)
    assert length(accounts) > 0
  end

  test "GET the same account properties for multiple identical requests", %{conn: conn} do
    account_id = "test_acc_Y0hHUVFMQmZCRERC"

    # Do the same request twice
    conn1 =
      conn
      |> put_req_header("authorization", "Basic dGVzdF9CRERCZkJMUVFHSGNfZ1dhc2Q6")
      |> get(Routes.api_path(conn, :show_account, account_id))
    conn2 =
      conn
      |> put_req_header("authorization", "Basic dGVzdF9CRERCZkJMUVFHSGNfZ1dhc2Q6")
      |> get(Routes.api_path(conn, :show_account, account_id))

    account_req1 = json_response(conn1, 200)
    account_req2 = json_response(conn2, 200)

    assert account_req1["id"] == account_id
    assert account_req2["id"] == account_id
    assert is_map(account_req1)
    assert is_map(account_req2)
    # Both requests returned the same name, account number and routing numbers
    assert account_req1["name"] == account_req2["name"]
    assert account_req1["account_number"] == account_req2["account_number"]
    assert account_req1["routing_numbers"]["ach"] == account_req2["routing_numbers"]["ach"]
    assert account_req1["routing_numbers"]["wire"] == account_req2["routing_numbers"]["wire"]
  end

  test "Latest transaction running balance is the same as account's available balance", %{conn: conn} do
    account_id = "test_acc_Y0hHUVFMQmZCRERC"
    reference_date = ~D[2020-07-09]

    # get transactions for the account
    conn =
      conn
      |> put_req_header("authorization", "Basic dGVzdF9CRERCZkJMUVFHSGNfZ1dhc2Q6")
      |> get(Routes.api_path(conn, :show_transactions, account_id))

    account = Enum.find(conn.assigns[:accounts], &(&1.id == account_id))

    transactions = json_response(conn, 200)
    current_date = Timex.to_naive_datetime(Timex.now())
    latest_transaction = Enum.find(transactions, &(Timex.parse!(&1["date"], "{YYYY}-{0M}-{0D}") <= current_date))

    assert latest_transaction["running_balance"] == account.balances.available
    assert is_list(transactions)
    assert length(transactions) == Timex.diff(Timex.today(), reference_date, :days) # Generated number of transactions is the difference of dates between now and the fixed reference
  end

  test "Sum of consecutive transaction amounts adds up", %{conn: conn} do
    account_id = "test_acc_Y0hHUVFMQmZCRERC"

    # Get transactions
    conn =
      conn
      |> put_req_header("authorization", "Basic dGVzdF9CRERCZkJMUVFHSGNfZ1dhc2Q6")
      |> get(Routes.api_path(conn, :show_transactions, account_id))

    transactions = json_response(conn, 200)

    current_date = Timex.to_naive_datetime(Timex.now())
    latest_transaction = Enum.find(transactions, &(Timex.parse!(&1["date"], "{YYYY}-{0M}-{0D}") <= current_date))
    prev_transaction =
       Enum.find(transactions,
        &(Timex.parse!(&1["date"], "{YYYY}-{0M}-{0D}") > Timex.parse!(latest_transaction["date"], "{YYYY}-{0M}-{0D}")))

    # Previous running balance + new amount = new running balance
    assert (prev_transaction["running_balance"] + latest_transaction["amount"]) == latest_transaction["running_balance"]
  end

  test "GET a single transaction", %{conn: conn} do
    account_id = "test_acc_Y0hHUVFMQmZCRERC"
    transaction_id = "test_txn_NTA1"
    conn =
      conn
      |> put_req_header("authorization", "Basic dGVzdF9CRERCZkJMUVFHSGNfZ1dhc2Q6")
      |> get(Routes.api_path(conn, :show_transaction, account_id, transaction_id))

    transaction = json_response(conn, 200)

    assert conn.status == 200
    assert is_map(transaction)
    assert transaction["id"] == "test_txn_NTA1"
    assert transaction["account_id"] == "test_acc_Y0hHUVFMQmZCRERC"
  end
end
