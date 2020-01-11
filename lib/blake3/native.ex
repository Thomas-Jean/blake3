defmodule Blake3.Native do
    use Rustler, otp_app: :blake3, crate: :native_blake3


    def hash(), do: error()
    # def new(), do: error()
    # def update(), do: error()
    # def finsh(), do: error()
    # def info(), do: error()
  
    defp error, do: :erlang.nif_error(:nif_not_loaded)
end
