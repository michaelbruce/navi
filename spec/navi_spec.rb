require_relative '../navi'

describe Navi do
  it 'says Hey Listen!' do
    STDOUT.should_receive(:puts).with('Hey Listen')
    Navi.new
  end
end
