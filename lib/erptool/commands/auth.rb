# frozen_string_literal: true

require_relative '../command'
require_relative '../services/auth_service'
require 'oauth2'
require 'launchy'
require 'tty-config'
require 'tty-prompt'
require 'tty-spinner'

module Erptool
  module Commands
    class Auth < Erptool::Command
      attr_reader :prompt, :spinner, :output
      
      def initialize
        @prompt = create_prompt
        @spinner = TTY::Spinner.new("[:spinner] Fetching OAuth token....",format: :pulse_2, clear: true)
        @output = $stdout
        config.write(force: true) unless config.exist?
      end

      def execute
        config.read
        client_id = config.fetch('CLIENT_ID')
        client_secret = config.fetch('CLIENT_SECRET')
        
        if client_id.nil? || client_secret.nil?
          set_client_information
        elsif client_id && client_secret && !token_valid?
          refresh_token
        else
          output.puts 'Your current token is valid'
        end
      end

      def set_client_information
        client_id, client_secret = prompt_user_for_auth_information

        if resp = credentials_valid?(client_id, client_secret)
          update_data = {
            'TOKEN_TYPE' => resp['token_type'],
            'TOKEN' => resp[:access_token],
            'REFRESH_TOKEN' => resp[:refresh_token],
            'EXPIRES_AT' => resp[:expires_at],
            'CREATED_AT' => resp['created_at']
          }
          update_config(update_data)
          output.puts 'Auth success, Welcome!'
        else
          output.puts 'Auth Unsuccessful: Client ID, Client Secret or bad paste of Authorization Code'
          prompt_user_for_auth_information
        end
      end

      def token_valid?
        # if current time is greater than set exp time, token is expired
        expiration_time = config.fetch('EXPIRES_AT')
        if expiration_time < Time.now.to_i # to test + 7200 
          output.puts "Your token expired..."
          false
        else
          true #token is valid no need to refresh
        end
      end

      def credentials_valid?(client_id, client_secret)
        base_url = 'https://login.procore.com'
        redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'
        oauth_client = OAuth2::Client.new(
          client_id,
          client_secret,
          site: base_url
        )

        access_token_url = oauth_client.auth_code.authorize_url(redirect_uri: redirect_uri)

        output.puts "Opening your default browser... Please login to Procore and copy the Authorization Code \n"
        sleep 2.5
        Launchy.open(access_token_url)

        access_code = prompt.ask('Paste your Authorization Code here: ') do |q|
          q.required true
          q.validate /(?:\w{64})/
        end
        
        spinner.auto_spin
        response = oauth_client.auth_code.get_token(access_code, redirect_uri: redirect_uri)
        spinner.stop

        response.to_hash
      rescue => e
        spinner.stop
        false
      end

      def prompt_user_for_auth_information
        client_id_and_secret_regex = /(?:\w{64})/
        data = prompt.collect do
          key('CLIENT_ID').ask('What is your Procore Client ID?') do |q|
            q.default ''
            q.validate(client_id_and_secret_regex, 'Client ID cannot contain special characters and must be a proper length') # regex for every char a-zA-Z0-9 and length of 64
          end
          
          key('CLIENT_SECRET').ask('What is your Procore Client Secret') do |q|
            q.default ''
            q.validate(client_id_and_secret_regex, 'Client Secret cannot contain special characters and must be a proper length')
          end
        end

        update_config( 
          { 
            'CLIENT_ID' => data['CLIENT_ID'], 
            'CLIENT_SECRET' => data['CLIENT_SECRET']
          }
        )
        [data['CLIENT_ID'], data['CLIENT_SECRET']]
      end
      
      def create_prompt
        TTY::Prompt.new(
          interrupt: -> { puts; exit 1 },
          input: $stdin, output: $stdout,
          clear: true,
        )
      end
    end
  end
end
