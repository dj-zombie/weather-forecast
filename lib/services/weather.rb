require 'dotenv'
require 'uri'
require 'net/http'
require 'openssl'
require 'date'

module Weather
  class Client
    def get_forecast(address)
      address = URI.encode_www_form_component(address)
      url = URI("https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{address}/#{Date.today}/?key=#{ENV["API_KEY"]}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(url)

      begin
        response = http.request(request)
        body = response.read_body
        weather = JSON.parse(body)

        weather["days"].each do |days|
          weather_date = days["datetime"]
          weather_desc = days["description"]
          weather_tmax = days["tempmax"]
          weather_tmin = days["tempmin"]

          puts "Forecast for date: #{weather_date}"
          puts " General conditions: #{weather_desc}"
          puts " The high temperature will be #{weather_tmax}"
          puts " The low temperature will be #{weather_tmin}"
        end
        weather
      rescue StandardError
        false
      end
    end
  end
end

