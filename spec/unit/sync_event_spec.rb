require 'erptool/commands/sync_event'

RSpec.describe Erptool::Commands::SyncEvent do
  it "executes `sync_event` command successfully" do
    output = StringIO.new
    options = {}
    command = Erptool::Commands::SyncEvent.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
