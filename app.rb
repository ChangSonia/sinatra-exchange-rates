require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

get("/") do

# Assemble the full URL string by adding the first part, the API token, and the last part together
list_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"

# Place a GET request to the URL
@list_response = JSON.parse(HTTP.get(list_url))

# Get currencies hash from response
@currencies = @list_response.fetch("currencies").keys

# Print out all possiblities
erb(:homepage) 
end



get("/:from_currency") do
    @original_currency = params.fetch("from_currency")

    list_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
    @list_response = JSON.parse(HTTP.get(list_url))
    @currencies = @list_response.fetch("currencies").keys

  erb(:from_currency) 

end



get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  @api_response = JSON.parse(HTTP.get(api_url))
  @exchange_rate = @api_response.fetch("result")

  erb(:exchange_rate)

end

    