# frozen_string_literal: true

require 'thor'
require 'pastel'
require 'tty-font'
require 'pry-byebug'

module Erptool
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner

    desc 'version', 'erptool version'
    def version
      require_relative 'version'
      puts "v#{Erptool::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'pcco', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def pcco(*)
      if options[:help]
        invoke :help, ['pcco']
      else
        require_relative 'commands/pcco'
        Erptool::Commands::Pcco.new(options).execute
      end
    end

    def help(*args)
      font =  TTY::Font.new(:standard)
      pastel = Pastel.new(enabled: !options['no-color'])
      puts pastel.red(font.write("ERP TOOL"))
      super
    end
    
    desc 'psi case_number', 'Generate a workspace file specific to PSI'
    method_option :help, aliases: '-h', type: :boolean, desc: 'Display usage information'
    method_option :init, aliases: '-i', type: :boolean, desc: 'Creates a PSI_notes directory inside home path, continues to refer to this location'
    method_option :link, aliases: '-l', type: :string, banner: 'path of existing psi_notes dir',desc: 'Provide a path to an existing psi_notes location'
    def psi(case_number)
      if options[:help]
        invoke :help, ['psi']
      else          
        require_relative 'commands/psi'
        Erptool::Commands::Psi.new(case_number,options).execute
      end
    end


    desc "auth" ,'Get a Procore OAuth2.0 Access Token'
    def auth
      if options[:help]
        invoke :help, ['auth']
      else
        require_relative 'commands/auth'
        Erptool::Commands::Auth.new.execute
      end
    end

    desc 'sync_event [set_successful/set_status]', 'Use the API to modify a sync event in Procore'
    long_desc <<-DESC
      Actions you can use: \n
        set_successful: Provided the Company ID and Procore Item ID, well set it to success \n
        set_status: User is prompted with a selection of: OK, Ready to Export, In Progress or Failed \n
DESC

    method_option :help, aliases: '-h', type: :boolean, desc: 'Display usage information'
    method_option :test, aliases: '-t', type: :boolean, desc: 'another option to run'
    def sync_event(action='')
      if options[:help]
        invoke :help, ['sync_event']
      else
        require_relative 'commands/sync_event'
        Erptool::Commands::SyncEvent.new(action).execute
      end
    end
  end
end
