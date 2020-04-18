defmodule Repository.Account.AccountRepository do
  @moduledoc """
    Manipulate Accounts data, isolating the persistence layer
  """

  @behaviour Repository

  @repository Application.get_env(
                :sistema_financeiro,
                :account_repository,
                Repository.Account.CSVRepository
              )

  def all do
    {:ok, do_all()}
  rescue
    e -> {:error, e.message}
  end

  defp do_all do
    @repository.all()
  end
end
