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

  defp do_all do
    database().all_data()
  end

  defp database do
    Application.get_env(:sistema_financeiro, :account_database)
  end
end
