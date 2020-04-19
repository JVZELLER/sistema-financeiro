defmodule Currency do
  @moduledoc """
  Estrutura de dados que representa moedas, seguindo os padrões da ISO 4217
  """

  alias __MODULE__, as: Currency
  alias Repository.Currency.CurrencyRepository, as: CurrencyRepository

  @currencies CurrencyRepository.all()

  defstruct alpha_code: "BRL",
            numeric_code: 986,
            exponent: 2,
            name: "Brazilian Real",
            symbol: "R$"

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

      true -> raise(ArgumentError, message: "#{alpha_code} must be atom or string")
    end
  end

  def get_factor(%Currency{exponent: exponent}) do
    :math.pow(10, exponent) |> round()
  end

  defp get!(alpha_code) do
    {_ok, currencies} = @currencies

    case Map.fetch(currencies, alpha_code) do
      {:ok, currency} -> {:ok, currency}
      :error -> raise ArgumentError,
        message: "Currency #{alpha_code} not found"
    end
  end

  def to_atom(%Currency{alpha_code: alpha_code}) do
    alpha_code |> String.to_existing_atom()
  end
end
