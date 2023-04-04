[![Hex.pm Version](http://img.shields.io/hexpm/v/blake3.svg?style=flat)](https://hex.pm/packages/blake3)

# Blake3

Elixir bindings for the Rust Blake3 implementation.
These bindings use [`:rustler`](https://github.com/rusterlium/rustler) to connect to the hashing functions.

## Installation

The package can be installed by adding `blake3` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:blake3, "~> 1.0"}
  ]
end
```

run `mix deps.get` and `mix deps.compile` to pull and build the bindings

## Configuration

There are feature options in the rust implementation that allow for additional SIMD instructions and multithreading. They can be set though environment variable or `Mix.Config`.

```shell
export BLAKE3_SIMD_MODE=neon
export BLAKE3_RAYON=true
```

or

```elixir
config :blake3,
   simd_mode: :neon,
   rayon: :true
```

- `neon` enables ARM NEON support
- `rayon` enables Rayon-based multithreading

When changing configuration you will need to call `mix deps.compile` to enable the features.

## Example Usage

```elixir
> Blake3.hash("foobarbaz")
#<<192, 154, 254, 224, 201, 243, 97 ...

> Blake3.new() |> Blake3.update("foo") |> Blake3.update("bar") |> Blake3.update("baz") |> Blake3.finalize()
#<<192, 154, 254, 224, 201, 243, 97 ...

> Blake3.hash("boom") |> Base.encode16(case: :lower)
#"a74bb4d1d4e44d0a2981d131762f45db9a211313d8e9f2cd151b4e673a35a6c1"
```

## Supported Elixir / Erlang / Rust

We follow Rustler itself, supporting latest three minor Elixir versions and major OTP versions.
As for Rust itself, we only support stable.

Documentation can found at [https://hexdocs.pm/blake3](https://hexdocs.pm/blake3).
