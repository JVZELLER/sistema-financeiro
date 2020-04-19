defmodule Account do
  @moduledoc false

  defstruct [:code, :owner, :balance]

  def new(code, owner, balance, currency_code) do
    %{
      code: code,
      owner: owner,
      balance: Money.new(balance, currency_code)
    }
  end
end
