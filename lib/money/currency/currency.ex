defmodule Currency do
  @moduledoc """
  Represents a Currency type accordingly to ISO 4217
  """

  alias __MODULE__, as: Currency
  alias Repository.Currency.CurrencyRepository, as: CurrencyRepository

  defstruct alpha_code: "BRL",
            numeric_code: 986,
            exponent: 2,
            name: "Brazilian Real",
            symbol: "R$"

  @doc """
  Finds `Currency` from a given `alpha_code`

  ## Examples:
  ```
    iex> Currency.find!(:BRL)
    {:ok, Currency{alpha_code: "BRL", exponent: 2, name: "Brazilian Real", numeric_code: 986, symbol: "R$"}
    iex> Currency.find!(:usd)
    {:ok, Currency{alpha_code: "USD", exponent: 2, name: "US Dollar", numeric_code: 840, symbol: "$"}
    iex> Currency.find!("brl")
    {:ok, Currency{alpha_code: "BRL", exponent: 2, name: "Brazilian Real", numeric_code: 986, symbol: "R$"}
    iex> Currency.find!(86)
    ** (ArgumentError) "86" must be atom or string
  """
  def find!(alpha_code) do
    cond do
      is_atom(alpha_code) ->
        Atom.to_string(alpha_code)
        |> String.upcase()
        |> String.to_atom()
        |> get!()

      is_binary(alpha_code) ->
        String.upcase(alpha_code)
        |> String.to_atom()
        |> get!()

      true ->
        raise(ArgumentError, message: "\"#{alpha_code}\" must be atom or string")
    end
  end

  @doc """
  Returns `Currency` exponent

  ## Examples:
  ```
    iex> Currency.get_factor(Currency.find!(:BRL))
    200
    iex> Currency.get_factor(Currency.find!(:JPY))
    0
  """
  def get_factor(%Currency{exponent: exponent}) do
    :math.pow(10, exponent) |> round()
  end

  defp get!(alpha_code) do
    {_ok, currencies} = CurrencyRepository.all()

    case Map.fetch(currencies, alpha_code) do
      {:ok, currency} -> {:ok, currency}
      :error -> {:error, raise_not_found_currency(alpha_code)}
    end
  end

  @doc """
  Returns the `alpha_code` represented as an `atom`

  ## Examples:
  ```
    iex> Currency.to_atom(Currency.find!(:JPY)
    :JPY
    iex> Currency.to_atom(Currency.find!(:BRL)
    :BRL
  """
  def to_atom(%Currency{alpha_code: alpha_code}) do
    alpha_code |> String.to_existing_atom()
  end

  defp raise_not_found_currency(alpha_code) do
    raise ArgumentError,
      message: "Currency #{alpha_code} not found"
  end
end
