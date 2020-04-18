defmodule SistemaFinanceiroTest do
  use ExUnit.Case
  doctest SistemaFinanceiro

  test "starts the app" do
    assert SistemaFinanceiro.start() == :start
  end
end
