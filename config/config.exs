use Mix.Config

config :blake3, Blake3.Native,
  mode: :release,
  features: MixBlake3.Project.config_features()
