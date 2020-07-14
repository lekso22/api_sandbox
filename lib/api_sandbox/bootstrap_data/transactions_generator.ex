defmodule ApiSandbox.TransactionsGenerator do
  require Integer


  def generate_transaction(account_id, n, running, amount, date) when n==1 do
    [
      %{
        type: "card_payment",
        running_balance: round_balance(running),
        id: gen_id(n),
        description: "Exxon Mobil",
        date: date,
        amount: amount,
        account_id: account_id,
        links: gen_links(account_id, n)
      }
    ]
  end

  def generate_transaction(account_id, n, running, amount, date) do
    [
      %{
        type: "card_payment",
        running_balance: round_balance(running),
        id: gen_id(n),
        description: "Exxon Mobil",
        date: date,
        amount: amount,
        account_id: account_id,
        links: gen_links(account_id, n)
      } | generate_transaction(account_id, n-1, running - (amount), gen_amount(amount, n), Timex.shift(date, days: -3 * n))
    ]
  end

  def gen_amount(amount, n) do
    amount = amount + n |> Float.round(2)
    _variable_sign =
      if Integer.is_even(n), do: amount, else: -1 * amount
  end

  def round_balance(running) do
    running |> Float.round(2)
  end

  def gen_id(n) do
    string_gen =
       Base.encode64(Integer.to_string(n * 100 + n), padding: false)

    "test_txn_#{string_gen}"
  end

  def extract_string_part(account_id) do
    String.split(account_id, "_") |> Enum.at(2)
  end

  def gen_links(account_id, n) do
    url = Application.fetch_env!(:api_sandbox, :url)
    %{
      self: "#{url}/api/accounts/#{account_id}/transactions/#{gen_id(n)}",
      account: "#{url}/api/accounts/#{account_id}"
    }
  end

end
