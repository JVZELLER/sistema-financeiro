defmodule AccountTest do
  use ExUnit.Case
  doctest Account

  test "Account.new/4" do
    balance = Money.new(10)

    assert %Account{code: "123", owner: "Doe", balance: balance} ===
             Account.new("123", "Doe", 10, :BRL)
  end
end
