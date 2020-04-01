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

  def add(money1, money2) do
    case validate_same_currency(money1, money2) do
      {:ok, currency} -> sum = money1.amount + money2.amount
                         %Money{amount: sum, currency: currency}
      {:error, reason} -> IO.puts reason
    end
  end

  def validate_same_currency(money1, money2) do
    if money1.currency === money2.currency do
      {:ok, money1.currency}
    else
      {:error, "Não é possível somar moedas diferentes."
        <> " Moedas #{money1.currency} e #{money2.currency}."
      }
    end
  end

  def parse_amount(amount) do
    {value, _} = Float.parse(amount)
    # converting amount to cents
     floor(value * 100)
  end
end
