defmodule SistemaFinanceiro do
  @moduledoc """
  Core module of the app where you can start the application
  and play around with the Accounts
  """

  @integer ~r/^[\+\-]?\d+(?:[\+\-]?\d+)?$/

  @float ~r/^[\+\-]?\d*\,?\d*\.?\d+(?:[\+\-]?\d+)?$/

  alias SistemaFinanceiro.Controller

  @doc """
  Starts the app by listing all accounts

  ## Examples
  ```
    iex> SistemaFinanceiro.start()
    ################################
                Accounts
    ################################
    Code     Owner          Balance
    1        Zé Doe         R$ 50.00

    2        Zeller Doe     R$ 50.00

    3        Ann Doe        $ 25.00

    4        Smith Doe      $ 100.00

    5        Xang Doe       $ 25.00

    6        Zang Doe       ¥ 50

    7        Xan Jack       ¥ 25


    (L)ist Accounts (S)plit Money (E)xchange (Q)uit:

  """
  def start do
    list_accounts()
    get_command()
  end

  defp get_command do
    input =
      IO.gets("\n(L)ist Accounts (S)plit Money (E)xchange (Q)uit: ")
      |> String.trim()
      |> String.downcase()

    case input do
      "l" ->
        list_accounts()

      "s" ->
        split_money()

      "e" ->
        exchange()

      "q" ->
        IO.puts("\nBye :)\n")
        System.halt()

      _ ->
        IO.puts("\nInvalid option!!!")
        get_command()
    end
  end

  defp list_accounts do
    case Controller.list_accounts() do
      {:ok, accounts} -> display_accounts(accounts)
      {:error, message} -> show_error("Listing Accounts", message)
    end

    get_command()
  end

  defp split_money do
    accounts = get_accounts_code()
    amount = get_amount()

    ratios =
      get_ratios()
      |> validate_number_of_ratios(accounts, &split_money/0)
      |> Enum.map(&String.to_integer/1)

    case Controller.split_money(accounts, amount, ratios) do
      {:ok, result} -> display_accounts(result)
      {:error, message} -> show_error("Spliting Money", message)
    end

    get_command()
  end

  defp exchange do
    account =
      get_account_code_to_exchange()
      |> String.trim()

    to_currency_code =
      get_currency_code()
      |> String.trim()

    case Controller.exchange_money([account], to_currency_code) do
      {:ok, result} -> display_accounts(result)
      {:error, message} -> show_error("Exchanging Money", message)
    end

    get_command()
  end

  defp display_accounts(accounts) do
    IO.puts("################################")
    IO.puts("\t  Accounts")
    IO.puts("################################")
    IO.puts("Code\t Owner \t\tBalance")

    Enum.each(accounts, fn account ->
      %{code: code, owner: owner, balance: balance} = account
      IO.puts("#{code}\t #{owner} \t#{Money.to_string(balance)}\n")
    end)
  end

  defp get_accounts_code do
    IO.puts("\n\n################################")
    IO.puts("\t Split Money")
    IO.puts("################################")
    IO.puts("Please, enter the following:")

    first =
      IO.gets("\nFirst account code (Ex.: 11): ")
      |> String.trim()

    second =
      IO.gets("Second account code (Ex.: 8): ")
      |> String.trim()

    validate_empty_input([first, second], &get_accounts_code/0)
  end

  defp get_account_code_to_exchange do
    IO.puts("\n\n################################")
    IO.puts("  Exchange Account Currency")
    IO.puts("################################")
    IO.puts("Please, enter the following:")

    first = IO.gets("\nAcount code (Ex.: 11): ")

    validate_empty_input(first, &get_account_code_to_exchange/0)
  end

  defp get_currency_code do
    IO.gets("\nCurrency code to exchange (Ex.: USD): ")
    |> validate_empty_input(&get_currency_code/0)
  end

  defp get_amount do
    IO.gets("\nAmount of money to be splited into the accounts (Ex.: 10.50): ")
    |> String.trim()
    |> validate_empty_input(&get_amount/0)
    |> validate_amount(&get_amount/0)
  end

  defp get_ratios do
    IO.gets("\nRatios to split the money into the accounts, separated by comma (Ex.: 3, 7): ")
    |> String.trim()
    |> String.split(",")
    |> validate_ratios(&get_ratios/0)
  end

  defp validate_empty_input(inputs, action_to_execute) when is_list(inputs) do
    is_empty = Enum.any?(inputs, fn input -> String.trim(input) === "" end)

    case is_empty do
      true ->
        IO.puts("\nPlease, enter a valid (non-empty) input!!")
        action_to_execute.()

      false ->
        inputs
    end
  end

  defp validate_empty_input(inputs, action_to_execute) do
    case String.trim(inputs) === "" do
      true ->
        IO.puts("\nPlease, enter a valid (non-empty) input!!")
        action_to_execute.()

      false ->
        inputs
    end
  end

  defp validate_ratios(ratios, action_to_execute) do
    is_numeric =
      Enum.any?(ratios, fn r -> String.trim(r) !== "" and is_valid_number(r, @integer) end)

    if !is_numeric do
      IO.puts("\nPlease, enter a valid (non-empty, numeric) input!!")
      action_to_execute.()
    else
      ratios
    end
  end

  defp validate_number_of_ratios(ratios, accounts, action_to_execute) do
    if length(accounts) !== length(ratios) do
      IO.puts("\nPlease, enter just two ratio values")
      action_to_execute.()
    else
      ratios
    end
  end

  defp validate_amount(input, action_to_execute) do
    case is_valid_number(input, @float) do
      false ->
        IO.puts("\nPlease, enter a valid (numeric) input!!")
        action_to_execute.()

      true ->
        input
    end
  end

  defp is_valid_number(input, to_match), do: String.match?(input, to_match)

  defp show_error(action, error_message) do
    IO.puts(
      "\n\nSorry, something wrong happening during the #{action}, please try again later :("
    )

    IO.puts("Error: #{error_message}")
  end
end
