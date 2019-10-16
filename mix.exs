defmodule Noether.MixProject do
  use Mix.Project

  def project do
    [
      app: :noether,
      version: "0.2.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      dialyzer: [plt_add_deps: :transitive],
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
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.19", only: :dev},
      {:dialyxir, "~> 1.0.0-rc.4", only: :dev, runtime: false},
      {:stream_data, "~> 0.1", only: :test}
    ]
  end

  defp aliases do
    [
      check: [
        "format --check-formatted mix.exs \"lib/**/*.{ex,exs}\" \"test/**/*.{ex,exs}\" \"priv/**/*.{ex,exs}\" \"config/**/*.{ex,exs}\"",
        "credo",
        "dialyzer --halt-exit-status"
      ],
      "format.all": [
        "format mix.exs \"lib/**/*.{ex,exs}\" \"test/**/*.{ex,exs}\" \"priv/**/*.{ex,exs}\" \"config/**/*.{ex,exs}\""
      ]
    ]
  end
end
