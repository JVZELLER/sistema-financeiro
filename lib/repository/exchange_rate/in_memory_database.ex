defmodule Repository.ExchangeRate.InMemoryDatabase do
  @moduledoc """
    Provides in memory accounts data.
    Data from [XE Currency Converter](https://www.xe.com/currencyconverter/)
  """

  @doc """
    Get all account data
  """
  def all_data do
    [
      %{rate: 5.31726, from: "USD", to: "BRL"},
      %{rate: 0.188088, from: "BRL", to: "USD"},
      %{rate: 107.755, from: "USD", to: "JPY"},
      %{rate: 0.00928031, from: "JPY", to: "USD"},
      %{rate: 20.2671, from: "BRL", to: "JPY"},
      %{rate: 0.0493412, from: "JPY", to: "BRL"},
    ]
  end
end
