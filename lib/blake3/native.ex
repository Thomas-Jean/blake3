defmodule Blake3.Native do
  @moduledoc """
  Blake3.Native is the rustler module that will be replaced with the nif rust functions.
  This module doesn't need to be called direcly.
  """

  use Rustler, otp_app: :blake3, crate: :blake3

  def hash(_str), do: error()
  def new(), do: error()
  def update(_state, _str), do: error()
  def finalize(_state), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
