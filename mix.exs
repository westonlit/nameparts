defmodule Nameparts.MixProject do
  use Mix.Project

  def project do
    [
      app: :nameparts,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      name: "nameparts",
      source_url: "https://github.com/westonlit/nameparts",
      docs: [extras: ["README.md"]]
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
      {:excoveralls, "~> 0.8", only: :test},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Takes a full name and splits it into individual name parts"
  end

  defp package do
    [
      name: "nameparts",
      maintainers: ["Weston Littrell"],
      licenses: ["FreeBSD"],
      links: %{"GitHub" => "https://github.com/westonlit/nameparts"}
    ]
  end
end
