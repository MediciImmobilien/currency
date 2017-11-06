defmodule Currency.Mixfile do
  	use Mix.Project

  	def project do
    	[app: :currency,
     	version: "0.3.0",
     	elixir: "~> 1.4",
     	build_embedded: Mix.env == :prod,
     	start_permanent: Mix.env == :prod,
     	deps: deps()]
  	end

	def application do
    	[extra_applications: [:logger, :httpoison, :money, :poison],mod: {Currency, []}]
 	end

	defp deps do
    	[{:httpoison, "~> 0.13.0"},
		{:money, "~> 1.2"},
	 	{:poison, "~> 3.1",override: :true}]
  	end
end
