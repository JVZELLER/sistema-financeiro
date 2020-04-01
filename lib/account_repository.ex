defmodule AccountRepository do
  require Account

  def all do
    read_accounts_from_csv()
      |> parse_account_data()
  end

  def read_accounts_from_csv do
    # TODO: Get relative path from system
    filename = "/home/zeller/Downloads/Projects/sistema-financeiro/lib/users.csv"
    case File.read(filename) do
      {:ok, content} -> String.trim(content)
      {:error, reason} -> IO.puts "Não consegui ler o arquivo: #{filename}... :("
                          IO.puts "#{:file.format_error reason}\n"
    end
  end

  def parse_account_data(data) do
    [headers | accounts] = String.split(data, ~r(\n))
    parse_lines(headers, accounts)
  end

  def parse_lines(headers, accounts) do
    attributes = String.split(headers, ",")
    Enum.reduce(accounts, %{}, fn account, accounts_map ->
      fields = String.split(account, ",")
      code = hd fields
      account = Enum.zip(attributes, fields)
        |> Enum.into(%{})
        |> Account.new()

      Map.put(accounts_map, code, account)
    end)
  end
end
