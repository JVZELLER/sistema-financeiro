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

  """
  def new(amount, currency_code \\ :BRL) when is_integer(amount) or is_float(amount) do
    do_new!(amount, currency_code)
  rescue
    e -> {:error, e.message}
  end

  @doc """
  Creates a new `Money` type with amount and currency: Default currency is `:BRL`

  ## Examples:
  ```
    iex> Money.new!(5)
    %Money{amount: 500, currency: :BRL}
    iex> Money.new!(5, :USD)
    %Money{amount: 500, currency: :USD}
    iex> Money.new!(5.78, :USD)
    iex> Money.new!(5, "new_currency")
    ** (ArgumentError) Currency NEW_CURRENCY not found

  """
  def new!(amount, currency_code \\ :BRL) when is_integer(amount) or is_float(amount) do
    do_new!(amount, currency_code)
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
  Divides `Money` from a given list of ratios

  ## Examples:
  ```
    iex> Money.divide(Money.new(7), [1, 9])
    [%Money{amount: 70, currency: :BRL}, %Money{amount: 630, currency: :BRL}]
    iex> Money.divide(Money.new(0.15), [3, 7])
    [%Money{amount: 5, currency: :BRL}, %Money{amount: 10, currency: :BRL}]
    iex> Money.divide(Money.new(0.10), [4, 6])
    [%Money{amount: 5, currency: :BRL}, %Money{amount: 6, currency: :BRL}]
    iex> Money.divide(Money.new(0.10), [4, "6"])
    ** (ArgumentError) Value "6" must be integer
  """
  def divide(%Money{currency: currency} = m, ratios) when is_list(ratios) do
    raise_if_not_valid_ratios(ratios)
    divisions = calculate_values_by_ratio(ratios, m.amount)
    rem = m.amount - sum_values(divisions)
    do_alocate(divisions, rem, currency)
  end

  @doc """
  Divides `Money` from a given a denominator

  ## Examples:
  ```
    iex> Money.divide(Money.new(10), 2)
    [%Money{amount: 500, currency: :BRL}, %Money{amount: 500, currency: :BRL}]
    iex> Money.divide(Money.new(9), 3)
    [%Money{amount: 300, currency: :BRL}, %Money{amount: 300, currency: :BRL}, %Money{amount: 300, currency: :BRL}]
    iex> Money.divide(Money.new(9, :USD), 1)
    [%Money{amount: 900, currency: :USD}]
    iex> Money.divide(Money.new(5), "2")
    ** (ArgumentError) Value "2" must be integer

  ```
  """
  def divide(%Money{currency: currency} = m, denominator) do
    raise_if_not_integer(denominator)
    raise_if_not_greater_than_zero(denominator)
    div = div(m.amount, denominator)
    rem = rem(m.amount, denominator)
    do_alocate(div, rem, currency, denominator)
  end

  defp calculate_values_by_ratio(ratios, amount) do
    total_ratio = sum_values(ratios)
    Enum.map(ratios, fn ratio -> div(amount * ratio, total_ratio) end)
  end

  defp sum_values(values) do
    values |> Enum.reduce(fn value, acc -> value + acc end)
  end

  defp do_alocate([head | tail], rem, currency) do
    amount =
      if rem > 0 do
        head + 1
      else
        head
      end

    money = %Money{amount: amount, currency: currency}

    remainder =
      if rem > 0 do
        rem - 1
      else
        rem
      end

    if tail != [] do
      [money | do_alocate(tail, remainder, currency)]
    else
      [money]
    end
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
    iex> Money.multiply(Money.new(15, :USD), 2)
    %Money{amount: 3000, currency: :USD}
    iex> Money.multiply(Money.new(750, :JPY), 3.5)
    %Money{amount: 2625, currency: :JPY}
    iex> Money.multiply(Money.new(750), "3.5")
    ** (ArgumentError) Value "3.5" must be integer or float

  ```
  """
  def multiply(%Money{currency: currency} = a, b) do
    raise_if_not_integer_or_float(b)
    raise_if_not_greater_than_zero(b)
    float_amount = float_value(a)
    do_new!(float_amount * b, currency)
  end

  defp float_value(%Money{currency: currency} = m) do
    currency_v = Currency.find!(currency)
    factor = Currency.get_factor(currency_v)
    Float.round(m.amount / factor, currency_v.exponent)
  end

  @doc """
  Parse an amount to `Money`

  ## Examples:
  ```
    iex> Money.parse("12")
    %Money{amount: 1200, currency: :BRL}
    iex> Money.parse("0,1")
    %Money{amount: 10, currency: :BRL}
    iex> Money.parse("12aa", :USD)
    {:error, "Cannot parse value \\"12aa\\""}
  """
  def parse(amount, currency \\ :BRL) when is_binary(amount) do
    parse!(amount, currency)
  rescue
    e -> {:error, e.message}
  end

  @doc """
  Parse an amount value to `Money`. Raises an error if the value is not a number

  ## Examples:
  ```
    iex> Money.parse!("12")
    %Money{amount: 1200, currency: :BRL}
    iex> Money.parse!("0.1", :USD)
    %Money{amount: 10, currency: :USD}
    iex> Money.parse!("0,1")
    %Money{amount: 10, currency: :BRL}
    iex> Money.parse!("bad", :USD)
    ** (ArgumentError) Cannot parse value "bad"
  """
  def parse!(amount, currency \\ :BRL) when is_binary(amount) do
    raise_if_not_number(amount)
    {_int, floating} = Integer.parse(amount)

    if floating !== "" do
      {value, _} = String.replace(amount, ",", ".") |> Float.parse()
      do_new!(value, currency)
    else
      {value, _} = Integer.parse(amount)
      do_new!(value, currency)
    end
  end

  @doc """
  Converts `Money` to formated string with properly symbol and number of decimal cases

  ## Examples:
  ```
    iex> Money.to_string(Money.new(4))
    "R$ 4.00"
    iex> Money.to_string(Money.new(25, :USD))
    "$ 25.00"
  """
  def to_string(%Money{currency: currency_code} = m) do
    currency = Currency.find!(currency_code)
    factor = Currency.get_factor(currency)
    formated_value =
      m.amount / factor
      |> :erlang.float_to_binary(decimals: currency.exponent)

    "#{currency.symbol} #{formated_value}"
  end

  defp raise_different_currencies(a, b) do
    raise ArgumentError,
      message: "Monies with different currencies. Got #{a.currency} and #{b.currency}"
  end

  defp raise_if_not_valid_ratios(ratios) do
    Enum.each(ratios, fn ratio ->
      raise_if_not_integer(ratio)
      raise_if_not_greater_than_zero(ratio)
    end)
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

  defp raise_if_not_number(number) do
    if !String.match?(number, ~r/^[\+\-]?\d*\,?\d*\.?\d+(?:[\+\-]?\d+)?$/) do
      raise ArgumentError,
        message: "Cannot parse value \"#{number}\""
    end
  end
end
