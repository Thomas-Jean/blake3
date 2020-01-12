defmodule Blake3 do
  @moduledoc """
  Blake3 provides bindings to the rust implementaion of the BLAKE3 hashing algorithm.
  See the [README](/blake3/doc/readme.html) for installation and usage examples
  """

  alias Blake3.Native

  @doc """
  Computes a message digest for the given data
  """
  def hash(data) do
    Native.hash(data)
  end

  @doc """
  returns a new reference for a Blake3 hasher to be used
  for streaming calls with update/2
  """
  def new() do
    Native.new()
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
end
