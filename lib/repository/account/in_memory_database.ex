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
      Account.new("2", "Zeller Doe", 50, :BRL),
      Account.new("3", "Ann Doe", 25, :USD),
      Account.new("4", "Smith Doe", 100, :USD),
      Account.new("5", "Xang Doe", 25, :USD),
      Account.new("6", "Zang Doe", 50, :JPY),
      Account.new("7", "Xan Jack", 25, :JPY)
    ]
  end
end
