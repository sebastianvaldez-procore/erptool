require 'erptool/commands/pcco'

RSpec.describe Erptool::Commands::Pcco do
  it "executes `pcco` command successfully" do
    output = StringIO.new
    options = {}
    command = Erptool::Commands::Pcco.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
