defmodule CurrencyTest do
  use ExUnit.Case
  doctest Currency

  test "find/1" do
    assert Currency.find(:BRL) == %Currency{
      alpha_code: "BRL",
      numeric_code: 986,
      exponent: 2,
      name: "Brazilian Real",
      symbol: "R$"
    }
    assert Currency.find(:BIT) == nil
  end

  test "find!/1" do
    assert Currency.find!(:BRL) == %Currency{
      alpha_code: "BRL",
      numeric_code: 986,
      exponent: 2,
      name: "Brazilian Real",
      symbol: "R$"
    }
    assert Currency.find!(:JPY) == %Currency{
      alpha_code: "JPY",
      numeric_code: 392,
      exponent: 0,
      name: "Yen",
      symbol: "¥"
    }
    assert_raise ArgumentError, fn -> Currency.find!(:BIT) end
  end

  test "get_factor/1" do
    assert Currency.get_factor(Currency.find(:BRL)) == 100
    assert Currency.get_factor(Currency.find(:JPY)) == 1
  end

  test "to_atom/1" do
  assert Currency.to_atom(Currency.find(:USD)) == :USD
  assert Currency.to_atom(Currency.find(:CNY)) == :CNY
  end
end
