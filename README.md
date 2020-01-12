# Blake3
Elixir bindings for the Rust Blake3 implementation.
These bindings use [`:rustler`](https://github.com/rusterlium/rustler) to connect to the hashing functions.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed by adding `blake3` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:blake3, "~> 0.1.0"}
  ]
end
```

run `mix deps.get` and `mix deps.compile` to pull and build the bindings

## Example Usage

```elixir
> Blake3.hash("foobarbaz")
#<<192, 154, 254, 224, 201, 243, 97 ...

> Blake3.new() |> Blake3.update("foo") |> Blake3.update("bar") |> Blake3.update("baz") |> Blake3.finalize()
#<<192, 154, 254, 224, 201, 243, 97 ...

```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/blake3](https://hexdocs.pm/_blake3).

### TO DO:
#### Basic Docs
#### Publish to Hex / Github release
#### Support Keyed Hashes