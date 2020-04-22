defmodule SistemaFinanceiro.AccountService do
  @moduledoc """
  A lightfull service to orchestrate incoming calls/requests actions from our controller
  """

  alias Repository.AccountRepository
  alias Repository.ExchangeRateRepository

  @doc """
  Lists all accounts

  ## Examples:
  ```
    iex> SistemaFinanceiro.AccountService.list()
    {
      :ok,
      [
        Account.new("1", "Zé Doe", 50, :BRL),
        Account.new("2", "Zeller Doe", 50, :BRL),
        Account.new("3", "Ann Doe", 25, :USD),
        Account.new("4", "Smith Doe", 100, :USD),
        Account.new("5", "Xang Doe", 25, :USD),
        Account.new("6", "Zang Doe", 50, :JPY),
        Account.new("7", "Xan Jack", 25, :JPY)
      ]
    }
  """
  def list do
    case AccountRepository.all() do
      {:ok, accounts} -> {:ok, accounts}
      {:error, error} -> {:error, error.message}
    end
  end

  @doc """
  Splits `Money` into accounts given an amount and ratios

  ## Examples:
  ```
    iex> SistemaFinanceiro.AccountService.split_money(["1", "5"], "0.05", [3,7])
    {:error, "Monies with different currencies. Got USD and BRL"}
    iex> SistemaFinanceiro.AccountService.split_money(["1", "2"], "0.05", [3,7])
    {:ok,
      [
       %Account{
         balance: %Money{amount: 5002, currency: :BRL},
         code: "1",
         owner: "Zé Doe"
       },
       %Account{
         balance: %Money{amount: 5003, currency: :BRL},
         code: "2",
         owner: "Zeller Doe"
       }
      ]
    }
  """
  def split_money(accounts_code, amount, ratios) do
    {:ok, find_accounts_by_code(accounts_code) |> do_split!(amount, ratios)}
  rescue
    e -> {:error, e.message}
  end

  def exchange_money(accounts_code, to_currency_code) do
    {:ok, find_accounts_by_code(accounts_code) |> do_exchange!(to_currency_code)}
  rescue
    e -> {:error, e.message}
  end

  defp find_accounts_by_code(accounts_code) do
    Enum.map(accounts_code, fn code ->
      case AccountRepository.find(code) do
        {:ok, nil} ->
          raise ArgumentError,
            message: "Account code #{code} not found"

        {:ok, account} ->
          account

        {:error, reason} ->
          raise ArgumentError, message: reason
      end
    end)
  end

  defp do_split!(accounts, amount, ratios) do
    money = Money.parse(amount)
    monies = Money.divide(money, ratios)
    allocate_money_to_accounts(accounts, monies)
  end

  defp allocate_money_to_accounts([head_acc | tail_acc], [head_m | tail_m]) do
    new_balance = Money.add(head_acc.balance, head_m)

    if tail_acc !== [] do
      [
        Account.update(head_acc, %{balance: new_balance})
        | allocate_money_to_accounts(tail_acc, tail_m)
      ]
    else
      [Account.update(head_acc, %{balance: new_balance})]
    end
  end

  defp do_exchange!(accounts, to_convert_currency_code) do
    Enum.map(accounts, fn acc ->
      m = acc.balance
      from_currency = Currency.find!(m.currency)
      to_currency = Currency.find!(to_convert_currency_code)

      result =
        same_currency(to_currency.alpha_code, from_currency.alpha_code) ||
          ExchangeRateRepository.find(%{
            to: to_currency.alpha_code,
            from: from_currency.alpha_code
          })

      case result do
        {:ok, nil} ->
          raise ArgumentError,
            message:
              "Exchange Rate from #{from_currency.alpha_code} to #{to_currency.alpha_code} not found"

        {:ok, exchange_rate} ->
          Account.update(acc, %{
            balance: Money.multiply(m, exchange_rate.rate, to_currency.alpha_code)
          })

        {:error, reason} ->
          raise ArgumentError, message: reason
      end
    end)
  end

  defp same_currency(to, from) do
    cond do
      to === from -> {:ok, %{rate: 1}}
      true -> false
    end
  end
end
