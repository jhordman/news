require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     
# enter your Dark Sky API key here
ForecastIO.api_key = "48bf33cc5ec4243ed7cd8671816f25cd"

# News API key
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=db70c932952e450c8bdfa53390981a9b"

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
    results = Geocoder.search(params["location"])
    @location = params["location"]
    @lat_long = results.first.coordinates # => [lat, long]
    @forecast = ForecastIO.forecast(@lat_long[0],@lat_long[1])
    @news = HTTParty.get(url).parsed_response.to_hash
    view "news"
end