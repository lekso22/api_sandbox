defmodule ApiSandbox.TransactionsGenerator do
  require Integer


  def generate_transaction(account_id, n, running, amount) when n == 1 do
    [
      %{
        type: "card_payment",
        running_balance: running,
        id: gen_id(account_id <> Integer.to_string(n)), 
        description: "Exxon Mobil",
        date: Timex.today(),
        amount: amount,
        account_id: account_id
      }
    ]
  end

  def generate_transaction(account_id, n, running, amount) do
      [
        %{
          type: "card_payment",
          running_balance: running,
          id: gen_id(account_id <> Integer.to_string(n)),
          description: "Exxon Mobil",
          date: Timex.today(),
          amount: amount,
          account_id: account_id,
        } | generate_transaction(account_id, n-1, running+amount, rand_float())
      ]
  end

  def rand_float() do
    :rand.uniform() * 10 |> Float.round(2)
  end

  def gen_id(account_id) do
    string_gen =
      account_id
      |> extract_string_part()
      |> Base.encode64(padding: false)
    
    "test_txn_#{string_gen}"
  end

  def extract_string_part(account_id) do
    String.split(account_id, "_") |> Enum.at(2)
  end

  def gen_ammount(balance) do
    # if rem(Float.ceil(balance), 2) == 0 do
    #   amount = balance + 123
    # else
      amount = balance - 123
    # end
  end
end