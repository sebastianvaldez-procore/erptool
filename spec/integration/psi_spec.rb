RSpec.describe "`erptool psi` command", type: :cli do
  it "executes `erptool help psi` command successfully" do
    output = `erptool help psi`
    expected_output = <<-OUT
Usage:
  erptool psi

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
