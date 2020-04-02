defmodule Account do
  require Money

  defstruct code: "", owner: "", balance: %Money{}

  def new(%{
        "code" => code,
        "owner" => owner,
        "balance" => balance,
        "currency_code" => currency_code
      }) do
    %{
      code: code,
      owner: owner,
      balance: Money.new(%{"amount" => balance, "currency_code" => currency_code})
    }
  end
end
