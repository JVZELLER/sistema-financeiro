defmodule Repository.CurrencyRepository do
  @moduledoc """
    Fetch Currency data
  """

  @behaviour Repository

  @doc """
  Returns all currencies data

  ## Exmaples:
  ```
    iex> Repository.CurrencyRepository.all()
    {
      :ok,
       %{
         BRL: %Currency{
           alpha_code: "BRL",
           exponent: 2,
           name: "Brazilian Real",
           numeric_code: 986,
           symbol: "R$"
         },
         CNY: %Currency{
           alpha_code: "CNY",
           exponent: 2,
           name: "Yuan Renminbi",
           numeric_code: 156,
           symbol: "¥"
         },
         JPY: %Currency{
           alpha_code: "JPY",
           exponent: 0,
           name: "Yen",
           numeric_code: 392,
           symbol: "¥"
         },
         USD: %Currency{
           alpha_code: "USD",
           exponent: 2,
           name: "US Dollar",
           numeric_code: 840,
           symbol: "$"
         }
       }
    }
  """
  def all do
    {:ok, do_all()}
  rescue
    e -> {:error, e}
  end

  @doc """
  Returns `Currency` from a given `Currency` code

  Not implemented
  """
  def find(_param) do
    {:ok, []}
  end

  defp do_all do
    database().all_data()
  end

  defp database do
    Application.get_env(:sistema_financeiro, :currency_database)
  end
end
