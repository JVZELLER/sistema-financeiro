defmodule Money do
  @moduledoc """
  Represents a Money type, inspired in [Martin Fowler's Money Patter](https://martinfowler.com/eaaCatalog/money.html)
  """

  defstruct [:amount, :currency]

  @doc """
  Creates a new `Money` type with amount and currency: Default currency is `:BRL`

  ## Examples:
  ```
    iex> Money.new(5)
    %Money{amount: 500, currency: :BRL}
    iex> Money.new(5, :USD)
    %Money{amount: 500, currency: :USD}
    iex> Money.new(5.78, :USD)
    %Money{amount: 578, currency: :USD}
    iex> Money.new(5, "USD")
    %Money{amount: 500, currency: :USD}
    iex> Money.new(5, "usd")
    %Money{amount: 500, currency: :USD}
    iex> Money.new(5, "new_currency")
    {:error, "Currency NEW_CURRENCY not found"}

  ```
  """
  def new(amount, currency_code \\ :BRL) when is_integer(amount) or is_float(amount) do
    do_new!(amount, currency_code)
  rescue
    e -> {:error, e.message}
  end

  defp do_new!(amount, currency_code) do
    currency = Currency.find!(currency_code)
    # Fator usado para conversoes pre-operacoes e para exibicao do dinheiro
    factor = Currency.get_factor(currency)
    %Money{amount: round(amount * factor), currency: Currency.to_atom(currency)}
  end

  @doc """
  Adds Monies (`Money`) with same currency

  ## Examples:
  ```
    iex> Money.add(Money.new(10), Money.new(1))
    %Money{amount: 1100, currency: :BRL}
    iex> Money.add(Money.new(5, :USD), Money.new(10, :usd))
    %Money{amount: 1500, currency: :USD}

  ```
  """
  def add(%Money{currency: currency} = a, %Money{currency: currency} = b) do
    %Money{amount: a.amount + b.amount, currency: currency}
  end

  @doc """
  Adds amount to `Money`

  ## Examples:
  ```
    iex> Money.add(Money.new(10), 1.50)
    %Money{amount: 1150, currency: :BRL}
    iex> Money.add(Money.new(5, :USD), 10)
    %Money{amount: 1500, currency: :USD}

  ```
  """
  def add(%Money{currency: currency} = a, b) when is_integer(b) or is_float(b) do
    add(a, Money.new(b, currency))
  end

  @doc """
  Raises different currencies exception

  ## Examples:
  ```
    iex> Money.add(Money.new(10), Money.new(10, :USD))
    ** (ArgumentError) Monies with different currencies. Got BRL and USD

  ```
  """
  def add(a, b) do
    raise_different_currencies(a, b)
  end

  @doc """
  Divides `Money` from a given a denominator

  ## Examples:
  ```
    iex> Money.divide!(Money.new(10), 2)
    [%Money{amount: 500, currency: :BRL}, %Money{amount: 500, currency: :BRL}]
    iex> Money.divide!(Money.new(9), 3)
    [%Money{amount: 300, currency: :BRL}, %Money{amount: 300, currency: :BRL}, %Money{amount: 300, currency: :BRL}]
    iex> Money.divide!(Money.new(9, :USD), 1)
    [%Money{amount: 900, currency: :USD}]
    iex> Money.divide!(Money.new(5), "2")
    ** (ArgumentError) Value "2" must be integer

  ```
  """
  def divide!(%Money{currency: currency} = m, denominator) do
    raise_if_not_integer(denominator)
    raise_if_not_greater_than_zero(denominator)
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

  @doc """
  Multiplies `Money` by amount

  ## Examples:
  ```
    iex> Money.multiply!(Money.new(15, :USD), 2)
    %Money{amount: 3000, currency: :USD}
    iex> Money.multiply!(Money.new(750, :JPY), 3.5)
    %Money{amount: 2625, currency: :JPY}
    iex> Money.multiply!(Money.new(750), "3.5")
    ** (ArgumentError) Value "3.5" must be integer or float

  ```
  """
  def multiply!(%Money{currency: currency} = a, b) do
    raise_if_not_integer_or_float(b)
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
      message: "Monies with different currencies. Got #{a.currency} and #{b.currency}"
  end

  defp raise_if_not_integer(value) do
    if !is_integer(value) do
      raise ArgumentError,
        message: "Value \"#{value}\" must be integer"
    end
  end

  defp raise_if_not_integer_or_float(value) do
    if !is_integer(value) and !is_float(value) do
      raise ArgumentError,
        message: "Value \"#{value}\" must be integer or float"
    end
  end

  defp raise_if_not_greater_than_zero(value) do
    if value <= 0 do
      raise ArgumentError,
        message: "Value \"#{value}\" must be greater than zero"
    end
  end
end
