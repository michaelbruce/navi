require_relative '../navi'

describe Navi do
  it 'says Hey Listen!' do
    expect(STDOUT).to receive(:puts).with('Hey Listen')
    Navi.new
  end
end
