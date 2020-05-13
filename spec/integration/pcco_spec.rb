RSpec.describe "`erptool pcco` command", type: :cli do
  it "executes `erptool help pcco` command successfully" do
    output = `erptool help pcco`
    expected_output = <<-OUT
Usage:
  erptool pcco

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
