defmodule Repository.Account.AccountRepository do
  @moduledoc """
    Manipulate Accounts data, isolating the persistence layer
  """

  @behaviour Repository

  def all do
    {:ok, do_all()}
  rescue
    e -> {:error, e}
  end

  def find(account_code) do
    {:ok, do_find(account_code)}
  rescue
    e -> {:error, e}
  end

  defp do_all do
    database().all_data()
  end

  defp do_find(code) do
    database().all_data() |> Enum.find(fn acc -> acc.code === code end)
  end

  defp database do
    Application.get_env(:sistema_financeiro, :account_database)
  end
end
