defmodule Repository.ExchangeRateRepository do
  @moduledoc """
    Fetchs exchange rate data. It could be get the data from database,
    call an API or even read from a file
  """

  @behaviour Repository

  def all do
    {:ok, do_all()}
  rescue
    e -> {:error, e}
  end

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
