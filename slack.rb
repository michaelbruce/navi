require 'net/http'
require 'json'

class Channel
  def initialize(name)
  end

  def id
  end
end

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

  def history(channel_name)
    send_request('channels.history', { channel: 'C099DPD3L' })['messages'].map{ |record| record['text'] }
  end

  def send_request(command, parameters=nil)
    if parameters
      parameters = '&channel=' + parameters[:channel]
      puts parameters
    else
      parameters = ''
    end

    uri = URI.parse("https://slack.com/api/#{command}?token=#{@token}#{parameters}")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
end
