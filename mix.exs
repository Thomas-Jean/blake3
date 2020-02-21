defmodule MixBlake3.Project do
  use Mix.Project

  def project do
    [
      app: :blake3,
      version: "0.3.0",
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
        mode: rustc_mode(Mix.env()),
        default_features: default_features?(),
        features: config_features()
      ]
    ]
  end

  defp rustc_mode(:prod), do: :release
  defp rustc_mode(_), do: :debug

  defp default_features? do
    simd = Application.get_env(:blake3, :simd_mode) || System.get_env("BLAKE3_SIMD_MODE")
    rayon = Application.get_env(:blake3, :rayon) || System.get_env("BLAKE3_RAYON")

    case {simd, rayon} do
      {nil, nil} -> true
      _ -> false
    end
  end

  defp config_features() do
    simd =
      case Application.get_env(:blake3, :simd_mode) || System.get_env("BLAKE3_SIMD_MODE") do
        "c" -> "c"
        :c -> "c"
        "c_neon" -> "c_neon"
        :c_neon -> "c_neon"
        _ -> "std"
      end

    rayon =
      case Application.get_env(:blake3, :rayon) || System.get_env("BLAKE3_RAYON") do
        "true" -> "rayon"
        true -> "rayon"
        _ -> nil
      end

    Enum.filter([simd, rayon], fn x -> x !== nil end)
  end
end
