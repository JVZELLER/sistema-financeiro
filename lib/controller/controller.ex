defmodule SistemaFinanceiro.Controller do
  @moduledoc """
  A controller to receive incoming calls/requests from our view, parse/adapt the data if necessary
  and bypass to the service layer
  """

  alias SistemaFinanceiro.AccountService

  def list_accounts do
    AccountService.list()
  end

  def split_money(accounts_code, money_amount, ratio) do
    AccountService.split_money(accounts_code, money_amount, ratio)
  end

  def exchange_money(accounts_code, to_currency_code) do
    AccountService.exchange_money(accounts_code, to_currency_code)
  end
end
