RSpec.describe "`erptool oauth` command", type: :cli do
  it "executes `erptool help oauth` command successfully" do
    output = `erptool help oauth`
    expected_output = <<-OUT
Usage:
  erptool oauth

Options:
  -h, [--help], [--no-help]  # Display usage information

Login via oAuth2.0 to Procore API to get access to a token for API calls
    OUT

    expect(output).to eq(expected_output)
  end
end
