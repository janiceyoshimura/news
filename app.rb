require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
require "open-uri"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "0e2b68d39b598d3d71244c8fe62da335"
   
get "/" do
  # show a view that asks for the location
   view "ask"
end

get "/newspaper" do
  # do everything else
   results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates # => [lat, long]
    forecast = ForecastIO.forecast("#{lat_long[0]}","#{lat_long[1]}").to_hash
    "#{lat_long[0]} #{lat_long[1]}"
    # test_location = "Chicago"
    
    current_temperature = forecast["currently"]["temperature"]
    conditions = forecast["currently"]["summary"]
    
    # NEWS API key
    url = "https://newsapi.org/v2/everything?q=#{params["q"]}&apiKey=eedac788ec124d788356e21b5043edbb"
    # url = "https://newsapi.org/v2/everything?q=Chicago&apiKey=eedac788ec124d788356e21b5043edbb"
    news = HTTParty.get(url).parsed_response.to_hash
    req = open(url)
    response_body = req.read

    @headline = news["articles"][0]["title"]
    @weather = "In #{params["q"]}, it is #{current_temperature} degrees and #{conditions.downcase}"
    @news_url = news["articles"][0]["url"]

    # Need to fix the for loop
    @all = 
    for line in news["articles"]
        puts "#{line["title"]}"
     end

    view "news"

end