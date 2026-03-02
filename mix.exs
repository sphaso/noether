defmodule Noether.MixProject do
  use Mix.Project

  def project do
    [
      app: :noether,
      version: "1.0.1",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      package: package(),
      description: "Algebra utilities for Elixir",
      docs: [main: "Noether"]
    ]
  end

  defp package do
    [
      maintainers: ["Tommaso Pifferi", "Simone Cottini", "Giovanni Ornaghi"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sphaso/noether"},
      source_url: "https://github.com/sphaso/noether"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7.11", only: :dev, runtime: false},
      {:ex_doc, "~> 0.35", only: :dev},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:stream_data, "~> 1.0", only: :test}
    ]
  end

  defp aliases do
    [
      check: [
        "format --check-formatted mix.exs \"lib/**/*.{ex,exs}\" \"test/**/*.{ex,exs}\" \"priv/**/*.{ex,exs}\" \"config/**/*.{ex,exs}\"",
        "credo",
        "dialyzer"
      ],
      "format.all": [
        "format mix.exs \"lib/**/*.{ex,exs}\" \"test/**/*.{ex,exs}\" \"priv/**/*.{ex,exs}\" \"config/**/*.{ex,exs}\""
      ]
    ]
  end
end
