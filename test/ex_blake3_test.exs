defmodule Blake3Test do
  use ExUnit.Case
  doctest Blake3

  test "greets the world" do
    assert Blake3.hello() == :world
  end
end
