defmodule Account do
  @moduledoc """
    Represents an Account type
  """

  defstruct [:code, :owner, :balance]

  @doc """
  Create a new Account type.

  ## Examples
    iex> Account.new("123", "Ze Doe", 100, :BRL)
    %Account{code: "123", owner: "Ze Doe", balance: %Money{amount: 10000, currency: :BRL}}
  """
  def new(code, owner, balance, currency_code) do
    %Account{
      code: code,
      owner: owner,
      balance: Money.new(balance, currency_code)
    }
  end

  @doc """
  Update an account

  ## Examples:
  ```
    iex> account = Account.new("123", "Ze Doe", 100, :BRL)
    iex> Account.update(account, %{owner: "Zé Doe"})
    %Account{code: "123", owner: "Zé Doe", balance: %Money{amount: 10000, currency: :BRL}}
    iex> Account.update(account, %{code: "321", owner: "Zeller"})
    %Account{code: "321", owner: "Zeller", balance: %Money{amount: 10000, currency: :BRL}}
  """
  def update(account, to_update) do
    account |> struct(to_update)
  end
end
