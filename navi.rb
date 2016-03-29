require_relative 'slack'

class Navi
  def initialize
    puts 'Hey Listen'
    token = read_config('.slacky')
    display_message('hi', {from: 'mike'})
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
    end
  end

  def read_config(config_name)
    config = open(ENV['HOME'] + '/' + config_name)
    config.readline.chomp
  end

end
