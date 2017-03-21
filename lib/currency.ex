defmodule Currency do
	def exchange_rate(currency_from, currency_to) do
		{:ok, %{body: body}} = HTTPoison.get("http://api.fixer.io/latest?base=USD&symbols=EUR")
		%{"rates" => %{"EUR" => exchange_rate}} = body |> Poison.decode!
		 exchange_rate
	end
	
	def from_usd_to_eur(%Money{amount: amount, currency: :USD}) do
		{:ok,new_amount} = amount * exchange_rate("USD", "EUR")
		|> Float.round(2)
		|> Money.parse(:EUR)
		new_amount
		|> Money.to_string
	end
end
