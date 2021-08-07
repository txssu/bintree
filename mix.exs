defmodule Bintree.MixProject do
  use Mix.Project

  def project do
    [
      app: :bintree,
      version: "1.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      source_url: "https://github.com/wmean-spec/bintree",

      description: "Creating and formatting binary trees.",

      package: [
        name: "bintree",
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/wmean-spec/bintree"},
      ],

      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:markex, "~> 1.1"},
    ]
  end
end
