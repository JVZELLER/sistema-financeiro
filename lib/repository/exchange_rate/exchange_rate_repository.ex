defmodule Repository.ExchangeRateRepository do
  @moduledoc """
    Fetchs exchange Rate data. It could get the data from database,
    call an API or even read from a file.
  """

  @behaviour Repository

  @doc """
  Gets all data

  ## Examples:
  ```
    iex> Repository.ExchangeRateRepository.all()
    {
      :ok,
       [
         %{from: "USD", rate: 5.31726, to: "BRL"},
         %{from: "BRL", rate: 0.188088, to: "USD"},
         %{from: "USD", rate: 107.755, to: "JPY"},
         %{from: "JPY", rate: 0.00928031, to: "USD"},
         %{from: "BRL", rate: 20.2671, to: "JPY"},
         %{from: "JPY", rate: 0.0493412, to: "BRL"}
       ]
    }
  """
  def all do
    {:ok, do_all()}
  rescue
    e -> {:error, e}
  end

  @doc """
  Finds ExchangeRate data from a given `to` and `from` parameter.

  ## Examples:
  ```
    iex> Repository.ExchangeRateRepository.find(%{to: "USD", from: "BRL"})
    {:ok, %{from: "BRL", rate: 0.188088, to: "USD"}}
    iex> Repository.ExchangeRateRepository.find(%{to: "JPY", from: "BRL"})
    {:ok, %{from: "BRL", rate: 20.2671, to: "JPY"}}
    iex> Repository.ExchangeRateRepository.find(%{to: "BLA", from: "BRL"})
    {:ok, nil}
  """
  def find(%{to: to, from: from}) do
    {:ok, do_find(to, from)}
  rescue
    e -> {:error, e}
  end

  defp do_all do
    database().all_data()
  end

  defp do_find(to, from) do
    database().all_data() |> Enum.find(fn ex -> ex.to === to and ex.from === from end)
  end

  defp database do
    Application.get_env(:sistema_financeiro, :exchange_database)
  end
end
