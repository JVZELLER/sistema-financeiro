defmodule Currency do
  @moduledoc """
  Estrutura de dados que representa moedas, seguindo os padrões da ISO 4217
  """

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
        |> String.to_existing_atom()
        |> get()

      is_binary(alpha_code) ->
        String.upcase(alpha_code)
        |> String.to_existing_atom()
        |> get()
    end
  end

  def get_factor(%Currency{exponent: exponent}) do
    :math.pow(10, exponent) |> round()
  end

  defp get(alpha_code) do
    currencies = CurrencyRepository.all()
    currencies[alpha_code]
  end

  def to_atom(%Currency{alpha_code: alpha_code}) do
    alpha_code |> String.to_existing_atom()
  end
end
