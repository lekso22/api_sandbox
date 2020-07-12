defmodule ApiSandbox.AccountsGenerator do
  require Integer
  alias ApiSandbox.TransactionsGenerator

  def generate_data(conn, token) do
    # IO.inspect conn
    token = extract_token_part(token)
     [
      %{
        id: gen_id(token),
        account_number: gen_account_number(token),
        balances: gen_balance(token),
        currency_code: "USD",
        enrollment_id: gen_enr_id(token),
        institution: gen_institution(token),
        name: "Teller API Sandbox Checking",
        routing_numbers: gen_routing_numbers(token)
      }
    ]
  end

  def gen_account_number(token) do
    num = gen_number(token)
    num_list = Integer.digits(num)
    # num = nil
    # IO.inspect num
    account_number =
      cond do
        num && length(num_list) < 10 -> Integer.to_string(1000000000 + num) 
        num && length(num_list) > 10 -> 
          num_list
          |> Enum.slice(0, 10)
          |> Integer.undigits()
        true -> num 
      end
  end

  def gen_balance(token) do
    running = 
      gen_number(token)
      |> :math.sqrt()
      |> Float.ceil(2)
    amount = :rand.uniform() * 10 |> Float.round(2)
    # amount = Enum.map(conn.assigns[:transactions], &(&1.balance)) |> Enum.sum()
    transaction_list = TransactionsGenerator.generate_transaction(gen_id(token), 3, running, amount)
    balance = List.last(transaction_list).running_balance |> Float.ceil(2)
    %{
      available: balance,
      ledger: balance
    }
  end

  def gen_enr_id(token) do
    string_gen =
      token
      |> Base.encode64(padding: false)
    
    "test_enr_#{string_gen}"
  end

  def gen_id(token) do
    string_gen =
      token
      |> String.reverse()
      |> Base.encode64(padding: false)
    
    "test_acc_#{string_gen}"
  end

  def gen_institution(token) do
    num =
      token
      |> String.to_charlist()
      |> Enum.sum()

    
    if Integer.is_even(num) do #can be done more cases, providing "proof of concept"
      %{
        id: "teller_bank",
        name: "The Teller Bank"
      }
      else
        %{
          id: "bank_of_america",
          name: "Bank of America"
        }
    end
  end

  def gen_routing_numbers(token) do
    num = gen_number(token)
    ach =
      num
      |> Integer.digits()
      |> Integer.undigits(16)
      |> Integer.to_string()
      |> String.split_at(9)
      |> elem(0)
      |> String.to_integer()
    wire =
      num
      |> Integer.digits()
      |> Enum.reverse()
      |> Integer.undigits(16)
      |> Integer.to_string()
      |> String.split_at(9)
      |> elem(0)
      |> String.to_integer()
     
    %{
      "ach": ach,
      "wire": wire
    }
  end

  def gen_number(token) do
      token
      |> String.to_charlist()
      |> Enum.map(&(Integer.to_string(&1)))
      |> Enum.join()
      |> String.to_integer()
      |> :math.sqrt()
      |> :math.sqrt()
      |> Float.to_string()
      |> String.split(".")
      |> List.last()
      |> String.to_integer()
  end

  def extract_token_part(token) do
    String.split(token, "_") |> Enum.at(1)
  end
end