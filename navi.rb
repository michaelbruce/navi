require_relative 'slack'

require 'httmultiparty'
require 'trollop'

class Navi
  include HTTMultiParty
  base_uri 'https://slack.com/api'

  def initialize
    puts 'Hey Listen'
    token = read_config('.slacky') # !> assigned but unused variable - token
    display_message('hi', {from: 'mike'})
    @token = read_config('.slacky')
    puts "token is #{@token}"
    cache_slack_data
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
    elsif lastCommand.chomp == '/ben'
      response = get_objects('im.history?channel=D030RQC90&count=10', 'messages')
      puts response.map{ |message| message['text'] }.reverse
    elsif lastCommand.chomp == '/users'
      all_usernames
    elsif lastCommand.chomp == '/slackdata'
      puts @user_records
    elsif lastCommand.chomp == '/channels'
      channels
      puts @channels.map { |channel| "#{channel['id']} #{channel['name']}" }
    elsif lastCommand.chomp == '/ims'
      puts 'Fetching all direct message channels between yourself and other users'
      ims
      puts @im.map { |im| "#{im['id']} #{im['user']} #{@user_records[im['user']]['name']}" }
    elsif lastCommand.chomp.start_with?('/')
      puts 'command not detected.. searching for usernames'
    end
  end

  def get_objects(method, key)
    self.class.get("/#{method}", query: { token: @token }).tap do |response|
      unless response['ok']
        raise "error retrieving #{key} from #{method}: " +
              "#{response.fetch('error', 'unknown error')}"
      end
    end.fetch(key)
  end

  def cache_slack_data
    users
    @user_records = {}
    users.each { |user| @user_records[user['id']] = user }
  end

  def channels
    @channels ||= get_objects('channels.list', 'channels')
  end

  def ims
    @im ||= get_objects('im.list', 'ims')
  end

  def history
    @history ||= get_objects('im.history', 'messages')
  end

  def users
    @users ||= get_objects('users.list', 'members')
  end

  def all_usernames
    puts @users.map{ |user| user['name'] }
  end

  def read_config(config_name)
    config = open(ENV['HOME'] + '/' + config_name)
    config.readline.chomp
  end

end
# ~> -:1:in `require_relative': cannot infer basepath (LoadError)
# ~> 	from -:1:in `<main>'
