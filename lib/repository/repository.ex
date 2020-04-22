defmodule Repository do
  @moduledoc """
    Defines a common behaviour to Repository implementations
  """

  @doc """
  Gets all data
  """
  @callback all() :: {:ok, data :: term} | {:error, reason :: term}

  @doc """
  Finds account by code
  """
  @callback find(term) :: {:ok, data :: term} | {:error, reason :: term}
end
