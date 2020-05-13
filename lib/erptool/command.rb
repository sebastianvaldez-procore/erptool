# frozen_string_literal: true
require 'forwardable'
require 'pry-byebug'
require 'httparty'

module Erptool
  class Command
    extend Forwardable

    def_delegators :command, :run

    # Main configuration
    # @api public
    def config
      @config ||= begin
        config = TTY::Config.new
        config.filename = 'procore_config'
        config.extname = '.json'
        config.append_path Dir.home
        config
      end
    end    

    def refresh_token
      config.read if config.exist?
      spinner = TTY::Spinner.new("[:spinner] Refreshing OAuth token....", format: :pulse_2, clear: true)
      base_url = 'https://login.procore.com'
      redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'
      grant_type = 'refresh_token'
      client_id = config.fetch('CLIENT_ID')
      client_secret= config.fetch('CLIENT_SECRET')
      refresh_token = config.fetch('REFRESH_TOKEN')

      # Manually build Refresh/GET token request
      refresh_url = 
      "#{base_url}/oauth/token?grant_type=#{grant_type}&client_id=#{client_id}&client_secret=#{client_secret}&refresh_token=#{refresh_token}&redirect_uri=#{redirect_uri}"
      spinner.auto_spin

      response = HTTParty.post(refresh_url).parsed_response

      # UPDATE CONFIG FILE
      refresh = {
        'TOKEN'         => response['access_token'],
        'REFRESH_TOKEN' => response['refresh_token'],
        'EXPIRES_AT'    => response['expires_in'] + response['created_at'],
        'CREATED_AT'    => response['created_at']
      }
      update_config(refresh)
      # config.set('TOKEN', value: response['access_token'])
      # config.set('REFRESH_TOKEN', value: response['refresh_token'])
      # config.set('EXPIRES_AT', value: response['expires_in'] + response['created_at'])
      # config.set('CREATED_AT', value: response['created_at'])
      # config.write(force: true)

      spinner.stop
      $stdout.puts 'Token refreshed successfully!'
      true # return true because token was refreshed successfully
    rescue => e
      spinner.stop
      $stdout.puts "Authorization Failed, please auth again.\n #{response['error_description']}"
      false
    end

    def update_config(data)
      data.keys.each do |key|
        config.set(key, value: data[key])
      end

      config.write(force: true)
    end

    # Execute this command
    #
    # @api public
    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    # The external commands runner
    #
    # @see http://www.rubydoc.info/gems/tty-command
    #
    # @api public
    def command(**options)
      require 'tty-command'
      TTY::Command.new(options)
    end

    # The cursor movement
    #
    # @see http://www.rubydoc.info/gems/tty-cursor
    #
    # @api public
    def cursor
      require 'tty-cursor'
      TTY::Cursor
    end

    # Open a file or text in the user's preferred editor
    #
    # @see http://www.rubydoc.info/gems/tty-editor
    #
    # @api public
    def editor
      require 'tty-editor'
      TTY::Editor
    end

    # File manipulation utility methods
    #
    # @see http://www.rubydoc.info/gems/tty-file
    #
    # @api public
    def generator
      require 'tty-file'
      TTY::File
    end

    # Terminal output paging
    #
    # @see http://www.rubydoc.info/gems/tty-pager
    #
    # @api public
    def pager(**options)
      require 'tty-pager'
      TTY::Pager.new(options)
    end

    # Terminal platform and OS properties
    #
    # @see http://www.rubydoc.info/gems/tty-pager
    #
    # @api public
    def platform
      require 'tty-platform'
      TTY::Platform.new
    end

    # The interactive prompt
    #
    # @see http://www.rubydoc.info/gems/tty-prompt
    #
    # @api public
    def prompt(**options)
      require 'tty-prompt'
      TTY::Prompt.new(options)
    end

    # Get terminal screen properties
    #
    # @see http://www.rubydoc.info/gems/tty-screen
    #
    # @api public
    def screen
      require 'tty-screen'
      TTY::Screen
    end

    # The unix which utility
    #
    # @see http://www.rubydoc.info/gems/tty-which
    #
    # @api public
    def which(*args)
      require 'tty-which'
      TTY::Which.which(*args)
    end

    # Check if executable exists
    #
    # @see http://www.rubydoc.info/gems/tty-which
    #
    # @api public
    def exec_exist?(*args)
      require 'tty-which'
      TTY::Which.exist?(*args)
    end
  end
end
