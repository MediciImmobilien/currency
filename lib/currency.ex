defmodule Currency do
	use GenServer
	use Application
	
	#API
	def from_usd_to_eur(amount), do: GenServer.call(Currencies, %{amount: amount, currency: :USD})
	
	#GenServer
	def start(_type, _args), do: {:ok, pid} = GenServer.start_link(Currency, {"USD", "EUR"}, name: Currencies)
	
	def init({from, to}), do: {:ok, update_rate(from, to)}
	
	def handle_call(%{amount: amount, currency: :USD}, _from, state) do
		rate = state |> state_up_to_date?
		{:reply, amount |> exchange(rate) , rate}	
	end
	
	#Implementation
	
	#check if current_rate is outdated
	def state_up_to_date?({rate,from,to, date}), do: Date.compare(date, Date.utc_today)|> state_up_to_date?({rate,from,to, date})
	
	#return current_rate
	def state_up_to_date?(:eq,{rate,from,to, date}), do: {rate,from,to, date}
	
	#fetch new rate
	def state_up_to_date?(:lt, {rate,from,to, date}), do: update_rate(from, to)
	
	#request new rate from fixer.io
	def update_rate(from, to), do: {url(from, to) |> request, from, to , Date.utc_today}
	
	# perform http request
	def request(url), do: url |> HTTPoison.get! |> handle_response 
	
	#handle response from http request
	def handle_response(%{body: body}), do: body |> Poison.decode! |> Map.get("rates") |> Map.get("EUR")

	#return api endpoint url
	def url(from, to), do: "https://api.fixer.io/latest?base=#{from}&symbols=#{to}"
	
	#exchange given amount by given rate return money struct
	def exchange(%{amount: amount, currency: :USD},{rate,_,_,_}) do 
		{:ok,new_amount} = amount * (rate/100)|> Float.round(2)|> Money.parse(:EUR)
		new_amount
	end
end