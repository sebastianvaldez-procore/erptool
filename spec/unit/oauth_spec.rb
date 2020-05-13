require 'erptool/commands/oauth'

RSpec.describe Erptool::Commands::Oauth do
  it "executes `oauth` command successfully" do
    output = StringIO.new
    options = {}
    command = Erptool::Commands::Oauth.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
