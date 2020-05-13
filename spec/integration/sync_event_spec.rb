RSpec.describe "`erptool sync_event` command", type: :cli do
  it "executes `erptool help sync_event` command successfully" do
    output = `erptool help sync_event`
    expected_output = <<-OUT
Usage:
  erptool sync_event

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
