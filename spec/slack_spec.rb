require_relative '../slack'

describe Slack do
  it 'recieves messages from slack' do
    token = 'a_security_token'
    expect(Slack.new(token).messages).to eq('message')
  end
end
