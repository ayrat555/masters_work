defmodule MastersWork.Mixfile do
  use Mix.Project

  def project do
    [app: :masters_work,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:csv, "~> 1.4.2"},
      {:clope, "~> 0.1.2"},
      {:rock, "~> 0.1.0"},
      {:apex, "~>1.0.0"},
      {:the_fuzz, git: "https://github.com/smashedtoatoms/the_fuzz"}
    ]
  end
end
