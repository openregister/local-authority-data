defmodule OrdinanceSurvey.Mixfile do
  use Mix.Project

  def project do
    [app: :ordinance_survey,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:data_morph, "~> 0.0.3"},
      {:poison, "~> 2.0"},
    ]
  end
end
