defmodule Blake3.Native do
  @moduledoc """
  Blake3.Native is the rustler module that will be replaced with the nif rust functions.
  This module doesn't need to be called direcly.
  """

  mix_config = Mix.Project.config()
  version = mix_config[:version]
  github_url = mix_config[:package][:links]["GitHub"]

  use RustlerPrecompiled,
    otp_app: :blake3,
    crate: "blake3",
    base_url: "#{github_url}/releases/download/v#{version}",
    force_build: System.get_env("BLAKE3_BUILD") in ["1", "true"],
    version: version,
    targets: ~w(
    arm-unknown-linux-gnueabihf
    aarch64-apple-darwin
    aarch64-unknown-linux-gnu
    aarch64-unknown-linux-musl
    riscv64gc-unknown-linux-gnu
    x86_64-apple-darwin
    x86_64-pc-windows-gnu
    x86_64-pc-windows-msvc
    x86_64-unknown-linux-gnu
    x86_64-unknown-linux-musl
  )s

  def hash(_str), do: error()
  def new(), do: error()
  def update(_state, _str), do: error()
  def update_rayon(_state, _str), do: error()
  def finalize(_state), do: error()
  def derive_key(_context, _key), do: error()
  def keyed_hash(_key, _str), do: error()
  def new_keyed(_key), do: error()
  def reset(_state), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
