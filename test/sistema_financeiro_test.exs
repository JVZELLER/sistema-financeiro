defmodule SistemaFinanceiroTest do
  use ExUnit.Case
  doctest SistemaFinanceiro

  test "greets the world" do
    assert SistemaFinanceiro.start() == :start
  end
end
