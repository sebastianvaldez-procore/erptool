
require 'tty-config'
class AuthService
  attr_reader :config

  def initialize(config)
    @config = config.read
  end

  def ensure_valid_token
    expiration_time = config.fetch('EXPIRES_AT')
    if expiration_time < Time.now.to_i # + 7200 
      refresh_token
    end

    config.fetch('TOKEN')
  end

  private

  def refresh_token
    base_url = 'https://api.procore.com'
    redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'
    grant_type = 'refresh_token'
    client_id = config.fetch('CLIENT_ID')
    client_secret= config.fetch('CLIENT_SECRET')
    refresh_token = config.fetch('REFRESH_TOKEN')

    refresh_url = 
    "#{base_url}/oauth/token?grant_type=#{grant_type}&client_id=#{client_id}&client_secret=#{client_secret}&refresh_token=#{refresh_token}&redirect_uri=#{redirect_uri}"

    response = HTTParty.post(refresh_url).parsed_response

    # UPDATE CONFIG FILE
    config.set('TOKEN', value: response['access_token'])
    config.set('REFRESH_TOKEN', value: response['refresh_token'])
    config.set('EXPIRES_AT', value: response['expires_in'] + response['created_at'])
    config.set('CREATED_AT', value: response['created_at'])
    config.write(force: true)

  rescue => e
    $stdout.puts 'Authorization Failed, please auth again.'
  end
end