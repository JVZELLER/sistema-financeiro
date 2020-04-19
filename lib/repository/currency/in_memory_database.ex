defmodule Repository.Currency.InMemoryDatabase do
  @moduledoc """
    Provides in memory currency data
  """

  @doc """
    Get all currency data
  """
  def all_data do
    %{
      BRL: %Currency{
        alpha_code: "BRL",
        numeric_code: 986,
        exponent: 2,
        name: "Brazilian Real",
        symbol: "R$"
      },
      USD: %Currency{
        alpha_code: "USD",
        numeric_code: 840,
        exponent: 2,
        name: "US Dollar",
        symbol: "$"
      },
      CNY: %Currency{
        alpha_code: "CNY",
        numeric_code: 156,
        exponent: 2,
        name: "Yuan Renminbi",
        symbol: "¥"
      },
      JPY: %Currency{
        alpha_code: "JPY",
        numeric_code: 392,
        exponent: 0,
        name: "Yen",
        symbol: "¥"
      }
    }
  end
end
