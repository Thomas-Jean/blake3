defmodule Blake3 do

    alias Blake3.Native
    
    def hash(str) do
        Native.hash(str)
    end

    def new() do
        Native.new()
    end
    
    def update(state, str) do
        Native.update(state, str)
    end
    
    def finalize(state) do
        Native.finalize(state)
    end

end
