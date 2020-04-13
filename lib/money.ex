defmodule Money do
  @moduledoc """
  Estrutra de dados que representa dinheiro.
  """
  defstruct [:amount, :currency]

  def new(amount, currency_code \\ :BRL) when is_integer(amount) or is_float(amount) do
    create(amount, currency_code)
  end

  defp create(amount, currency_code) do
    currency = Currency.find!(currency_code)
    # Fator usado para conversoes pre-operacoes e para exibicao do dinheiro
    factor = Currency.get_factor(currency)
    %Money{amount: round(amount * factor), currency: Currency.to_atom(currency)}
  end

  def add(%Money{currency: currency} = a, %Money{currency: currency} = b) do
    %Money{amount: a.amount + b.amount, currency: currency}
  end

  def add(%Money{currency: currency} = a, b) when is_integer(b) or is_float(b) do
    add(a, Money.new(b, currency))
  end

  def add(a, b) do
    raise_different_currencies(a, b)
  end

  def divide(%Money{currency: currency} = m, denominator) when is_integer(denominator) do
    div = div(m.amount, denominator)
    rem = rem(m.amount, denominator)
    alocate(div, rem, currency, denominator)
  end

  defp alocate(value, rem, currency, times) do
     cond do
       rem > 0 and times > 0 -> [%Money{amount: value + 1, currency: currency} | alocate(value, rem - 1, currency, times - 1)]
       rem <= 0 and times > 0 -> [%Money{amount: value, currency: currency} | alocate(value, rem, currency, times - 1)]
       true -> []
     end
  end

  def raise_different_currencies(a, b) do
    raise ArgumentError,
      message: "Não é possível realizar operações com moedas diferentes. Moedas: #{a.currency} e #{b.currency}"
  end
end
