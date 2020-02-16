defmodule Blake3 do
  @moduledoc """
  Blake3 provides bindings to the rust implementaion of the BLAKE3 hashing algorithm.
  See the [README](readme.html) for installation and usage examples
  """

  alias Blake3.Native

  @doc """
  computes a message digest for the given data
  """
  def hash(data) do
    Native.hash(data)
  end

  @doc """
  computes a message digest for the given data and key.
  The key must be 32 bytes. if you need to use a key of a
  diffrent size you can use `derive_key` to get a key of
  a proper size.
  """
  def keyed_hash(key, data) when byte_size(key) == 32 do
    Native.keyed_hash(key, data)
  end

  def keyed_hash(_key, _data) do
    {:error, "Error: Key must be 32 bytes"}
  end

  @doc """
  returns a new reference for a Blake3 hasher to be used
  for streaming calls with update/2
  """
  def new() do
    Native.new()
  end

  @doc """
  returns a new reference for a Blake3 hasher using the passed key
  to be used for streaming calls with update/2
  """
  def new_keyed(key) when byte_size(key) == 32 do
    Native.new_keyed(key)
  end

  def new_keyed(_key) do
    {:error, "Error: Key must be 32 bytes"}
  end

  @doc """
  updates the hasher with the given data to be hashed the
  the refernce can be continouly passed to update/2 or
  when finished to finalize/1
  """
  def update(state, data) do
    Native.update(state, data)
  end

  @doc """
  returns the binary of the current hash state for a
  given hasher
  """
  def finalize(state) do
    Native.finalize(state)
  end

  @doc """
  returns a 32 byte key for use for `hash_keyed` or `new_keyed` from
  the given context and key. for more information: [crate](https://github.com/BLAKE3-team/BLAKE3#the-blake3-crate)
  """
  def derive_key(context, key) do
    Native.derive_key(context, key)
  end

  @doc """
  same as `derive_key/2` but uses an empty string for context
  """
  def derive_key(key) do
    Native.derive_key("", key)
  end

  @doc """
  reset a hasher to the default stat like when calling Blake3.new
  """
  def reset(state) do
    Native.reset(state)
  end
end
