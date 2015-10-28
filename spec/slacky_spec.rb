require 'rspec'
require_relative '../slacky'

describe Slacky do

  it 'prints a startup message' do
    expect(Slacky.new("token").hi).to eq('hello there')
  end

end
