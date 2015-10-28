#!/usr/bin/env ruby

require 'httmultiparty'
require 'trollop'

# TODO More info on posting messages here:
# https://api.slack.com/methods/chat.postMessage/test
# https://github.com/rlister/slackcat/blob/master/bin/slackcat

class Slacky
  include HTTMultiParty
  base_uri 'https://slack.com/api'

  def initialize(token='')
    @token = token
    @token = read_config if @token == ''
  end

  def cli_ui
    puts 'Slacky alpha CLI'
    while input = STDIN.gets.chomp
      case input
      when /\/send/
        puts "Sending message #{input.gsub('/send','')} to AMA."
        post_message({channel: '#ama', text: "#{input.gsub('/send','')}", username: 'mikepjb'})
      when "/exit"
        puts "Goodbye."
        break;
      else
        puts 'You entered this: ' + input
      end
    end
  end

  def hi
    'hello there'
  end

  ## get a channel, group, im or user list
  def get_objects(method, key)
    self.class.get("/#{method}", query: { token: @token }).tap do |response|
      raise "error retrieving #{key} from #{method}: #{response.fetch('error', 'unknown error')}" unless response['ok']
    end.fetch(key)
  end

  def users
    @users ||= get_objects('users.list', 'members')
  end

  # get my username
  def auth
    @auth ||= get_objects('auth.test', 'user')
  end

  def groups
    @groups ||= get_objects('groups.list', 'groups')
  end

  def channels
    @channels ||= get_objects('channels.list', 'channels')
  end

  def ims
    @ims ||= get_objects('im.list', 'ims')
  end

  def history
    @history ||= get_objects('im.history', 'messages')
  end

  # def search_messages
  #   @search_result ||= get_objects('search.messages', 'messages')
  # end

  def post_message(params)
    self.class.post('/chat.postMessage', body: params.merge({token: @token})).tap do |response|
      raise "error posting message: #{response.fetch('error', 'unknown error')}" unless response['ok']
    end
  end

  def pm_slackbot(message)
    channel_id = self.class.post('/im.open', body: {token: @token, user: 'USLACKBOT'}).tap do |response|
      raise "error opening pm channel: #{response.fetch('error', 'unknown error')}" unless response['ok']
    end.fetch('channel')['id']

    puts "channel_id: #{channel_id}"

    post_message({channel: "#{channel_id}", text: message, username: 'mikepjb'})
  end

  ## translate a username into an IM id
  def im_for_user(username)
    user = users.find do |u|
      u['name'] == username
    end
    ims.find do |im|
      im['user'] == user['id']
    end
  end

  # def send(message, channel)
  #   url = "https://slack.com/api/chat.postMessage"
  #   full_test_url = "https://slack.com/api/chat.postMessage?token=<token!>&channel=%23ama&text=hi%20slacky&username=myusername&pretty=1"
  # end
  def read_config
    config = open(ENV['HOME']+'/.slacky')
    config.readline.chomp
  end

end

#slacky = Slacky.new
