defmodule Blake3.Native do
    use Rustler, otp_app: :blake3, crate: :blake3


    def hash(_str), do: error()
    def new(), do: error()
    def update(_state, _str), do: error()
    def finalize(_state), do: error()
  
    defp error, do: :erlang.nif_error(:nif_not_loaded)
end
