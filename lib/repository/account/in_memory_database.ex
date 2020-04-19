defmodule Repository.Account.InMemoryDatabase do
  @moduledoc """
    Provides in memory accounts data
  """

  @doc """
    Get all account data
  """
  def all_data do
    [
      Account.new("1", "Zé Doe", 50, :BRL),
      Account.new("2", "Ann Doe", 50, :USD),
      Account.new("3", "Xang Doe", 50, :JPY)
    ]
  end
end
