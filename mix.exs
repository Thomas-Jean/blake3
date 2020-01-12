defmodule Blake3.MixProject do
  use Mix.Project

  def project do
    [
      app: :blake3,
      version: "0.1.0",
      elixir: "~> 1.8",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      compilers: [:rustler] ++ Mix.compilers(),
      rustler_crates: rustler_crates(),
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  defp package() do
    [
      description: "Elixir binding for the Rust Blake3 implementation",
      files: ["lib", "native", ".formatter.exs", "README*", "LICENSE*", "mix.exs"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/Thomas-Jean/blake3"}
    ]
  end

  defp deps do
    [
      {:rustler, "~>0.21"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme",
      source_url: "https://github.com/Thomas-Jean/blake3"
    ]
  end

  defp rustler_crates do
    [
      blake3: [
        path: "native/blake3",
        mode: rustc_mode(Mix.env())
      ]
    ]
  end

  defp rustc_mode(:prod), do: :release
  defp rustc_mode(_), do: :debug
end
