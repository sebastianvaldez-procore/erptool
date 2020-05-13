require 'erptool/commands/psi'

RSpec.describe Erptool::Commands::Psi do
  it "executes `psi` command successfully" do
    output = StringIO.new
    options = {}
    command = Erptool::Commands::Psi.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
