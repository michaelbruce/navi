require_relative '../slack'

# TODO abstract to new class
def read_config
  config = open(ENV['HOME']+'/.slacky')
  config.readline.chomp
end

describe Slack do
  let (:token) { read_config }

  it 'gets a list of all channels' do
    expect(Slack.new(token).channels).to eq(["general", "random", "votes"])
  end

  pending 'gets the history given a channel name'
  #expect(Slack.new(token).history('general')).to eq(["hiii"])
end
