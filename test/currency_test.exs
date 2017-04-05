defmodule CurrencyTest do
  use ExUnit.Case
  doctest Currency

  test from usd to eur do
    assert from_usd_to_eur(%{amount: amount, currency: :USD})
  end
end
