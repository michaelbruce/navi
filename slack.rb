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

  def channels
    send_request('channels.list')['channels'].map{ |record| record['name'] }
  end

  def history(channel_name)
    send_request('channels.history', { channel: 'C099DPD3L' })['messages'].map{ |record| record['text'] }
  end

  def urlize_parameters(parameters)
    parameters.keys.map { |option| "&#{option}=" + parameters[option] }.join
  end

  def send_request(command, parameters={})
    uri = URI.parse("https://slack.com/api/#{command}?token=#{@token}#{urlize_parameters(parameters)}")
    JSON.parse(Net::HTTP.get_response(uri).body)
  end
end
