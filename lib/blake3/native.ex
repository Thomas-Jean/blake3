defmodule Blake3.Native do
    use Rustler, otp_app: :blake3, crate: :blake3


    def hash(str), do: error()
    def new(), do: error()
    def update(blakeRef, str), do: error()
    def finalize(blakeRef), do: error()
  
    defp error, do: :erlang.nif_error(:nif_not_loaded)
end
