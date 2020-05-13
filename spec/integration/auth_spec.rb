RSpec.describe "`erptool auth` command", type: :cli do
  it "executes `erptool help auth` command successfully" do
    output = `erptool help auth`
    expected_output = <<-OUT
Usage:
  erptool auth CLIENT_SECRET CLIENT_ID TOKEN REFRESH_TOKEN

Options:
  -h, [--help], [--no-help]  # Display usage information

Set up erptool with oAuth2.0 token for any commands that use APIs
    OUT

    expect(output).to eq(expected_output)
  end
end
