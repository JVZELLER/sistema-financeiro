defmodule Account do
  @moduledoc """
    Represents an Account type
  """

  defstruct [:code, :owner, :balance]

  @doc """
  Create a new Account type.

  ## Examples
    iex> Account.new("123", "Ze Doe", 100, :BRL)
    %{code: "123", owner: "Ze Doe", balance: %Money{amount: 10000, currency: :BRL}}
  """
  def new(code, owner, balance, currency_code) do
    %{
      code: code,
      owner: owner,
      balance: Money.new(balance, currency_code)
    }
  end
end
