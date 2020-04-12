defmodule Money do
  @moduledoc """
  Estrutra de dados que representa dinheiro.
  """
  defstruct [:amount, :currency]

  def new(amount, currency_code) when is_integer(amount) do
    create(amount, currency_code)
  end

  def new(string_amount, currency_code) when is_binary(string_amount) do
    {parsed_amount, _} = Integer.parse(string_amount)
    create(parsed_amount, currency_code)
  end

  defp create(amount, currency_code) do
    currency = Currency.find!(currency_code)
    # Fator usado para conversoes pre-operacoes e para exibicao do dinheiro
    factor = Currency.get_factor(currency)
    %Money{amount: amount * factor, currency: Currency.to_atom(currency)}
  end

  def add(%Money{currency: currency} = a, %Money{currency: currency} = b) do
    %Money{amount: a.amount + b.amount, currency: currency}
  end

  def add(a, b) do
    raise_different_currencies(a, b)
  end

  def raise_different_currencies(a, b) do
    raise ArgumentError,
      message: "Não é possível realizar operações com moedas diferentes. Moedas: #{a.currency} e #{b.currency}"
  end
end
