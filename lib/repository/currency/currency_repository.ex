defmodule Repository.Currency.CurrencyRepository do
  @moduledoc """
    Fetch Currency data
  """

  @behaviour Repository

  def all do
    {:ok, do_all()}
  rescue
    e -> {:error, e}
  end

  defp do_all do
    database().all_data()
  end

  defp database do
    Application.get_env(:sistema_financeiro, :currency_database)
  end
end
