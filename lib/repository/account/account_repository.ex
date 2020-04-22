defmodule Repository.AccountRepository do
  @moduledoc """
    Manipulate Accounts data, isolating the persistence layer
  """

  @behaviour Repository

  @doc """
  Returns all accounts data

  ## Examples:
  ```
    iex> Repository.AccountRepository.all()
    {
      :ok,
      [
        Account.new("1", "Zé Doe", 50, :BRL),
        Account.new("2", "Zeller Doe", 50, :BRL),
        Account.new("3", "Ann Doe", 25, :USD),
        Account.new("4", "Smith Doe", 100, :USD),
        Account.new("5", "Xang Doe", 25, :USD),
        Account.new("6", "Zang Doe", 50, :JPY),
        Account.new("7", "Xan Jack", 25, :JPY)
      ]
    }
  """
  def all do
    {:ok, do_all()}
  rescue
    e -> {:error, e}
  end

  @doc """
  Finds account by a given account's code

  ## Examples:
  ```
    iex> Repository.AccountRepository.find("1")
    {
      :ok,
       %Account{
         balance: %Money{amount: 5000, currency: :BRL},
         code: "1",
         owner: "Zé Doe"
       }
    }
    iex> Repository.AccountRepository.find("7")
    {
      :ok,
       %Account{
         balance: %Money{amount: 25, currency: :JPY},
         code: "7",
         owner: "Xan Jack"
       }
    }
    iex> Repository.AccountRepository.find("778")
    {:ok, nil}

  """
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
