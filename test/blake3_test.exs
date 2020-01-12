defmodule Blake3Test do
  use ExUnit.Case

  test "hashes a string produces a binary" do

    assert is_binary(Blake3.hash("foobarbaz"))
  end

  test "hashing the same string produces the same hash" do

    hash1 = Blake3.hash("foobarbaz")
    hash2 = Blake3.hash("foobarbaz")

    assert hash1 == hash2
  end

  test "hashing diffrent strings produces diffrent hashes" do

    hash1 = Blake3.hash("foobarbaz")
    hash2 = Blake3.hash("java.lang.OutOfMemoryError")

    assert hash1 != hash2
  end

  test "hashing can be done incrementally" do

    hasher = Blake3.new()

    Blake3.update(hasher, "foo")
    Blake3.update(hasher, "bar")
    Blake3.update(hasher, "baz")

    assert is_binary(Blake3.finalize(hasher))
  end


  test "hashing incrementally and all at once produce the same hash" do

    hasher = Blake3.new()

    Blake3.update(hasher, "foo")
    Blake3.update(hasher, "bar")
    Blake3.update(hasher, "baz")
    
    assert Blake3.finalize(hasher) == Blake3.hash("foobarbaz")
  end

  test "hasing incrementally can be pipelined" do
    hash = Blake3.new()
    |> Blake3.update("foo")
    |> Blake3.update("bar")
    |> Blake3.update("baz")
    |> Blake3.finalize()

    assert is_binary(hash)
  end

end
