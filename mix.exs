defmodule Telemetry.Instrument.MixProject do
  use Mix.Project

  def project do
    [
      app: :telemetry_instrument,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        maintainers: ["Joshua Nussbaum"],
        licenses: ["MIT"],
        links: %{github: "https://github.com/joshnuss/telemetry_instrument"}
      ],
      description: """
      Convenience function for Elixir's telemetry package
      """
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
      {:telemetry, "~> 0.4"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
