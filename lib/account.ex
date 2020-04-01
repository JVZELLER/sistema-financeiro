defmodule Account do
  require Money

  def new(entry) do
     %{
       code: entry["code"],
       owner: entry["owner"],
       balance: Money.new(%{
         "amount" => String.to_integer(entry["balance"]),
         "currency_code" => entry["currency_code"]
      })
     }
  end
end
