defmodule Money do
  defstruct amount: 0, currency: :BRL

  def new(entry) do
    %Money{
      # always represented as cents
      amount: parse_amount(entry["amount"]),
      currency: entry["currency_code"]
    }
  end

  def display(money) do
    "#{money.amount} #{money.currency}"
  end

  def add(%Money{:amount => a1, :currency => c1}, %Money{:amount => a2, :currency => c2}) do
    case validate_same_currency(c1, c2) do
      {:ok, currency} ->
        sum = a1 + a2
        %Money{amount: sum, currency: currency}

      {:error, reason} ->
        IO.puts(reason)
    end
  end

  def add(%Money{:amount => money_amount, :currency => currency}, amount) do
    sum = money_amount + floor(amount * 100)
    %Money{amount: sum, currency: currency}
  end

  def validate_same_currency(c1, c2) do
    if c1 === c2 do
      {:ok, c1}
    else
      {:error,
       "Não é possível somar moedas diferentes." <>
         " Moedas: #{c1} e #{c2}."}
    end
  end

  def parse_amount(amount) do
    {value, _} = Float.parse(amount)
    # converting amount to cents
    floor(value * 100)
  end
end
