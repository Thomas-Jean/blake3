defmodule Blake3 do
  @moduledoc """
  Blake3 provides bindings to the rust implementaion of the BLAKE3 hashing algorithm.
  See the [README](readme.html) for installation and usage examples
  """

  alias Blake3.Native

  @type hasher :: reference()

  @doc """
  computes a message digest for the given data
  """
  @spec hash(data :: binary()) :: binary()
  def hash(data) do
    Native.hash(data)
  end

  @doc """
  computes a message digest for the given data and key.
  The key must be 32 bytes. if you need to use a key of a
  diffrent size you can use `derive_key` to get a key of
  a proper size.
  """
  @spec keyed_hash(key :: binary(), data :: binary()) :: binary() | {:error, String.t()}
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
  @spec new() :: hasher()
  def new() do
    Native.new()
  end

  @doc """
  returns a new reference for a Blake3 hasher using the passed key
  to be used for streaming calls with update/2
  """
  @spec new_keyed(key :: binary()) :: hasher() | {:error, String.t()}
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
  @spec update(state :: hasher(), data :: binary()) :: hasher()
  def update(state, data) do
    Native.update(state, data)
  end

  @doc """
  returns the binary of the current hash state for a
  given hasher
  """
  @spec finalize(state :: hasher()) :: binary()
  def finalize(state) do
    Native.finalize(state)
  end

  @doc """
  returns a 32 byte key for use for `hash_keyed` or `new_keyed` from
  the given context and key. for more information: [crate](https://github.com/BLAKE3-team/BLAKE3#the-blake3-crate-)
  """
  @spec derive_key(context :: binary(), key :: binary()) :: binary()
  def derive_key(context, key) do
    Native.derive_key(context, key)
  end

  @doc """
  same as `derive_key/2` but uses an empty string for context
  """
  @spec derive_key(key :: binary()) :: binary()
  def derive_key(key) do
    Native.derive_key("", key)
  end

  @doc """
  reset a hasher to the default stat like when calling Blake3.new
  """
  @spec derive_key(state :: hasher()) :: hasher()
  def reset(state) do
    Native.reset(state)
  end

  @doc """
  updates state with the potential to multithreading. The rayon
  feature needs to be enabled and the input need to be large enough.
  for more information see:
  [documentation](https://docs.rs/blake3/1.0.0/blake3/struct.Hasher.html#method.update_rayon)
  """
  @spec update_rayon(state :: hasher(), data :: binary()) :: hasher()
  def update_rayon(state, data) do
    Native.update_rayon(state, data)
  end
end
