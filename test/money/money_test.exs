defmodule MoneyTest do
  use ExUnit.Case, async: true
  doctest Money

  describe "tests Money creation" do
    test "new/1" do
      assert Money.new(1) == %Money{amount: 100, currency: :BRL}
      assert Money.new(2.5) == %Money{amount: 250, currency: :BRL}
    end

    test "new/2" do
      assert Money.new(1, :USD) == %Money{amount: 100, currency: :USD}
      assert Money.new(2.5, :BRL) == %Money{amount: 250, currency: :BRL}
      assert Money.new(20, :XJK) == {:error, "Currency XJK not found"}
    end

    test "new!/1" do
      assert Money.new(1) == %Money{amount: 100, currency: :BRL}
      assert Money.new(4.77) == %Money{amount: 477, currency: :BRL}
    end

    test "new!/2" do
      assert Money.new(1, :USD) == %Money{amount: 100, currency: :USD}
      assert Money.new(1.75, :USD) == %Money{amount: 175, currency: :USD}
      assert_raise ArgumentError, fn -> Money.new!(1, :USB) end
    end
  end

  describe "tests Money.add" do
    test "add/2 with two monies" do
      assert Money.add(Money.new(1), Money.new(1)) == Money.new(2)
      assert Money.add(Money.new(3), Money.new(0.5)) == Money.new(3.5)
      assert_raise ArgumentError, fn -> Money.add(Money.new(3, :BRL), Money.new(0.5, :USD)) end
    end

    test "add/2 with Money and amount" do
      assert Money.add(Money.new(1), 5) == Money.new(6)
      assert Money.add(Money.new(3), 0.77) == Money.new(3.77)
    end
  end

  describe "tests Money.divide" do
    test "divide/2" do
      assert Money.divide(Money.new(5), 2) == [
               Money.new(2.5),
               Money.new(2.5)
             ]

      assert Money.divide(Money.new(99, :USD), 2) == [
               Money.new(49.5, :USD),
               Money.new(49.5, :USD)
             ]
    end

    test "divide/2 raise not integer" do
      assert_raise ArgumentError, fn -> Money.divide(Money.new(50), "2") end
    end

    test "divide/2 raise not greater than zero" do
      assert_raise ArgumentError, fn -> Money.divide(Money.new(50), -2) end
    end
  end

  describe "tests multiply/2" do
    test "multiply/2" do
      assert Money.multiply(Money.new(25), 2) == Money.new(50)
      assert Money.multiply(Money.new(7.40), 2) == Money.new(14.8)
      assert Money.multiply(Money.new(3), 2.5) == Money.new(7.5)
    end

    test "multiply/3" do
      assert Money.multiply(Money.new(25), 2, :USD) == Money.new(50, :USD)
      assert Money.multiply(Money.new(7.40), 2, :CNY) == Money.new(14.8, :CNY)
      assert Money.multiply(Money.new(3, :USD), 2.5, :BRL) == Money.new(7.5)
    end
  end
end
