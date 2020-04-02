defmodule SistemaFinanceiro do
  require Money
  require AccountRepository

  def start do
    AccountRepository.all()
      |> list_accounts()
  end

  def list_accounts(accounts \\ %{}) do
    IO.puts "Código\t | Titular\t | Saldo"
    Map.keys(accounts)
      |> Enum.each(
          fn code ->
          %{:owner => owner, :balance => balance} = accounts[code]
          IO.puts "#{code}\t #{owner}\t #{Money.display(balance)}"
        end)

    get_command(accounts)
  end

  def get_command(accounts) do
    input = IO.gets("\n(L)istar usuários \t(R)ateio entre usuários \t(C)âmbio \t(S)air: ")
      |> String.trim()
      |> String.downcase()

    case input do
        "c" -> IO.puts "\nImplement CAMBIO function"
        "l" -> list_accounts(accounts)
        "r" -> IO.puts "\nImplement SPLIT function"
        "s" -> IO.puts "\nAté breve :)\n"
        _   -> IO.puts "\nInforme uma opção válida!!!"
               get_command(accounts)
      end
  end
end
