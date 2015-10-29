require_relative '../slack'

describe Slack do
  let (:token) { 'xoxp-9319972838-12392936294-13441575734-4043a1a708' }

  it 'gets a list of all channels' do
    expect(Slack.new(token).channels).to eq(["general", "random", "votes"])
  end

end
