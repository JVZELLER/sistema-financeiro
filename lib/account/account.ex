defmodule Account do
  @moduledoc false

  defstruct [:code, :owner, :balance]

  def new(%{
        "code" => code,
        "owner" => owner,
        "balance" => balance,
        "currency_code" => currency_code
      }) do
    %{
      code: code,
      owner: owner,
      balance: Money.new(balance, currency_code)
    }
  end
end
