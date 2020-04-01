defmodule Account do
  require Money

  def new(entry) do
     %{
       code: entry["code"],
       owner: entry["owner"],
       balance: Money.new(%{
         "amount" => entry["balance"],
         "currency_code" => entry["currency_code"]
      })
     }
  end
end
