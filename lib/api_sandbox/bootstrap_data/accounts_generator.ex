defmodule ApiSandbox.AccountsGenerator do
  require Integer

  def generate_data(token) do
    # all the data will be generated based on the auth token
    if !is_nil(token) do
      token = extract_token_part(token)
      [
        %{
          id: gen_id(token),
          account_number: gen_account_number(token),
          balances: gen_balance(token),
          currency_code: "USD",
          enrollment_id: gen_enr_id(token),
          institution: gen_institution(token),
          name: "API Sandbox Checking",
          routing_numbers: gen_routing_numbers(token),
          links: gen_links(token)
        }
      ]
    end
  end

  def gen_account_number(token) do
    num = gen_number(token)
    num_list = Integer.digits(num)
    _account_number =
      cond do
        # Just making sure that all account numbers are consistently of 10 digits
        length(num_list) < 10 -> Integer.to_string(1000000000 + num)
        length(num_list) > 10 ->
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

    running = Timex.day(Timex.today) * running / 1000 |> Float.round(2) # Balance will change daily
    %{
      available: running,
      ledger: running
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


    if Integer.is_even(num) do #can be done more cases, just providing "proof of concept"
      %{
        id: "fake_bank",
        name: "The Fake Bank"
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
    # Both numbers are of 9 digits
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
      ach: ach,
      wire: wire
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

  def gen_links(token) do
    # Generating links manually in this case
    url = Application.fetch_env!(:api_sandbox, :url)
    %{
      self: "#{url}/api/accounts/#{gen_id(token)}",
      transactions: "#{url}/api/accounts/#{gen_id(token)}/transactions"
    }
  end

  def extract_token_part(token) do
    # Only the part between the two underscores of the token is relevant
    String.split(token, "_") |> Enum.at(1)
  end
end
