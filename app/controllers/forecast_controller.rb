require 'services/weather'
require 'json'

class ForecastController < ApplicationController

  def index
    if params[:address]
      expires_in 1.minutes, :public => true
      forecast = Weather::Client.new.get_forecast(params[:address])
      if forecast
        @data = JSON.pretty_generate(forecast)
        @temp = forecast["days"][0]["temp"]
        @high = forecast["days"][0]["tempmax"]
        @low = forecast["days"][0]["tempmin"]
        @errors = false
      else
        @errors = "Invalid input"
      end
    end
  end
end
