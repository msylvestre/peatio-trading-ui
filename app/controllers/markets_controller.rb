require 'uri'

class MarketsController < ApplicationController
  def show
    response = Faraday.get(market_variables_url, params.slice(:lang), 'Cookie' => request.headers['HTTP_COOKIE'])
    if response.status.to_i % 100 == 4
      head response.status
    else
      response.assert_success!
      @data = JSON.load(response.body).deep_symbolize_keys
    end
  end

private

  def fiat_ccy
    @data.fetch(:currencies).find { |ccy| ccy.fetch(:type) == 'fiat' }
  end
  helper_method :fiat_ccy

  def market_variables_url
    url = URI.parse(ENV.fetch('PLATFORM_ROOT_URL'))
    url = URI.join(url, '/markets/')
    URI.join(url, params[:id] + '.json')
  end
end