defmodule Repository do
  @moduledoc """
    Defines a common behaviour to Repository implementations
  """

  @doc """
    Get all data
  """
  @callback all() :: {:ok, data :: term} | {:error, reason :: term}
end
