defmodule Repository.Account.CSVRepository do
  @moduledoc """
    Provides Account data from CSV file
  """

  @behaviour Repository

  def all do
    accounts =
      read_accounts_from_csv()
      |> parse_account_data()

    {:ok, accounts}
  end

  defp read_accounts_from_csv do
    filename = Path.expand("lib/users.csv")

    case File.read(filename) do
      {:ok, content} ->
        String.trim(content)

      {:error, reason} ->
        IO.puts("Não foi possível ler o arquivo: #{filename}... :(")
        IO.puts("#{:file.format_error(reason)}\n")
    end
  end

  defp parse_account_data(data) do
    [headers | accounts] = String.split(data, ~r(\n))
    parse_lines(headers, accounts)
  end

  defp parse_lines(headers, accounts) do
    attributes = String.split(headers, ",")

    Enum.reduce(accounts, %{}, fn account, accounts_map ->
      fields = String.split(account, ",")
      code = hd(fields)

      account =
        Enum.zip(attributes, fields)
        |> Enum.into(%{})
        |> Account.new()

      Map.put(accounts_map, code, account)
    end)
  end
end
