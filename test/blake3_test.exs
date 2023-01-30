defmodule Blake3Test do
  use ExUnit.Case

  test "hashing a string produces a binary" do
    assert is_binary(Blake3.hash("foobarbaz"))
  end

  test "hashing a string produces a known good hash" do
    hash1 = Blake3.hash("The quick brown fox jumps over the lazy dog")

    hash2 =
      Base.decode16!("2f1514181aadccd913abd94cfa592701a5686ab23f8df1dff1b74710febc6d4a",
        case: :lower
      )

    assert hash1 == hash2
  end

  test "hashing the same string produces the same hash" do
    hash1 = Blake3.hash("foobarbaz")
    hash2 = Blake3.hash("foobarbaz")

    assert hash1 == hash2
  end

  test "hashing diffrent strings produces different hashes" do
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

  test "hashing incrementally can be pipelined" do
    hash =
      Blake3.new()
      |> Blake3.update("foo")
      |> Blake3.update("bar")
      |> Blake3.update("baz")
      |> Blake3.finalize()

    assert is_binary(hash)
  end

  test "derive key returns a key of 32 bytes" do
    key = Blake3.derive_key("example context", "example key")

    assert byte_size(key) == 32
  end

  test "using a keyed function with a bad key returns an error" do
    {:error, error} = Blake3.keyed_hash("key", "data")

    assert error == "Error: Key must be 32 bytes"
  end

  test "keyed hashes returns a binary as normal" do
    key = Blake3.derive_key("boom")
    digest = Blake3.keyed_hash(key, "data")

    assert is_binary(digest)
  end

  test "keyed hashes are not the same as a regular hashes" do
    key = Blake3.derive_key("boom")
    digest1 = Blake3.keyed_hash(key, "data")
    digest2 = Blake3.hash("data")

    assert digest1 !== digest2
  end

  test "hashing the same data with different keys produce different hashes" do
    key1 = Blake3.derive_key("boom")
    key2 = Blake3.derive_key("bang")

    digest1 = Blake3.keyed_hash(key1, "data")
    digest2 = Blake3.keyed_hash(key2, "data")

    assert digest1 !== digest2
  end

  test "keyed hashes can also be pipelined" do
    hash =
      Blake3.derive_key("zap")
      |> Blake3.new_keyed()
      |> Blake3.update("foo")
      |> Blake3.update("bar")
      |> Blake3.update("baz")
      |> Blake3.finalize()

    assert is_binary(hash)
  end

  test "hashers can be reset" do
    hash1 = Blake3.hash("data")

    hash2 =
      Blake3.new()
      |> Blake3.update("a string that won't affect the results because reset will be called")
      |> Blake3.reset()
      |> Blake3.update("data")
      |> Blake3.finalize()

    assert hash1 == hash2
  end

  test "update_rayon can be used instead of update (needs rayon feature enabled)" do
    hasher = Blake3.new()

    Blake3.update_rayon(hasher, "foo")
    Blake3.update_rayon(hasher, "bar")
    Blake3.update_rayon(hasher, "baz")

    hash1 = Blake3.finalize(hasher)
    hash2 = Blake3.hash("foobarbaz")

    assert is_binary(hash1)
    assert hash1 == hash2
  end
end
