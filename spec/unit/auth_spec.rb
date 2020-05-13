require 'erptool/commands/auth'

RSpec.describe Erptool::Commands::Auth do
  it "executes `auth` command successfully" do
    output = StringIO.new
    client_secret = nil
    client_id = nil
    token = nil
    refresh_token = nil
    options = {}
    command = Erptool::Commands::Auth.new(client_secret, client_id, token, refresh_token, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
