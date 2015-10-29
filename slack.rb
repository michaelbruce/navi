require 'net/http'
require 'json'

class Slack
  def initialize(token)
    @token = token
  end

  def messages
    'message'
  end

  def channels
    send_request('channels.list')['channels'].map{ |record| record['name'] }
  end

  def send_request(command, parameters=nil)
    if parameters
      parameters = '&' + 'key=value'.join('&')
    else
      parameters = ''
    end

    uri = URI.parse("https://slack.com/api/#{command}?token=#{@token}#{parameters}")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
end
