defmodule Money do
  @moduledoc """
  Estrutra de dados que representa dinheiro.
  """
  defstruct [:amount, :currency]

  def new(amount, currency_code \\ :BRL) when is_integer(amount) or is_float(amount) do
    do_new!(amount, currency_code)
  end

  defp do_new!(amount, currency_code) do
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
    raise_if_not_valid_denominator(denominator)
    div = div(m.amount, denominator)
    rem = rem(m.amount, denominator)
    do_alocate(div, rem, currency, denominator)
  end

  defp do_alocate(value, rem, currency, times) do
    cond do
      rem > 0 and times > 0 ->
        [
          %Money{amount: value + 1, currency: currency}
          | do_alocate(value, rem - 1, currency, times - 1)
        ]

      rem <= 0 and times > 0 ->
        [%Money{amount: value, currency: currency} | do_alocate(value, rem, currency, times - 1)]

      true ->
        []
    end
  end

  def multiply(%Money{currency: currency} = a, b) when is_integer(b) or is_float(b) do
    float_amount = float_value(a)
    do_new!(float_amount * b, currency)
  end

  defp float_value(%Money{currency: currency} = m) do
    currency_v = Currency.find!(currency)
    factor = Currency.get_factor(currency_v)
    Float.round(m.amount / factor, currency_v.exponent)
  end

  defp raise_different_currencies(a, b) do
    raise ArgumentError,
      message:
        "Não é possível realizar operações com moedas diferentes. Moedas: #{a.currency} e #{
          b.currency
        }"
  end

  defp raise_if_not_valid_denominator(denominator) do
    if denominator <= 0 do
      raise ArgumentError,
        message: "Denominador precisa ser maior que zero"
    end
  end
end
