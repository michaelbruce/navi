require_relative 'slack'

require 'httmultiparty'
require 'trollop'

class Navi
  include HTTMultiParty
  base_uri 'https://slack.com/api'

  def initialize
    puts 'Hey Listen'
    token = read_config('.slacky')
    display_message('hi', {from: 'mike'})
    @token = read_config('.slacky')
    puts "token is #{@token}"
    while true
      user_input
    end
    #Slack.new(token).history('ok')[0..3].each { |message| puts message }
  end

  def display_message(message, details={})
    puts 'slack:mike # what\'s for lunch?'
  end

  def user_input
    print 'mike => '
    lastCommand = gets
    puts "You entered, #{lastCommand}"
    if lastCommand.chomp == 'exit'
      exit
    elsif lastCommand.chomp == '/tech'
      response = get_objects('channels.history?channel=C02N593H6', 'messages')
      puts response.map{ |message| message['text'] }
    elsif lastCommand.chomp == '/users'
      all_usernames
    elsif lastCommand.chomp == '/channels'
      channels
      puts @channels.map { |channel| "#{channel['id']} #{channel['name']}" }
    end
  end

  def get_objects(method, key)
    self.class.get("/#{method}", query: { token: @token }).tap do |response|
      raise "error retrieving #{key} from #{method}: #{response.fetch('error', 'unknown error')}" unless response['ok']
    end.fetch(key)
  end

  def channels
    @channels ||= get_objects('channels.list', 'channels')
  end

  def history
    @history ||= get_objects('im.history', 'messages')
  end

  def users
    @users ||= get_objects('users.list', 'members')
  end

  def all_usernames
    users
    puts @users.map{ |user| user['name'] }
  end

  def read_config(config_name)
    config = open(ENV['HOME'] + '/' + config_name)
    config.readline.chomp
  end

end
