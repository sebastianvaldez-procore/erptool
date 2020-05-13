# frozen_string_literal: true

require_relative '../command'
require 'tty-config'
require 'pry-byebug'

module Erptool
  module Commands
    class Psi < Erptool::Command
      attr_reader :options, :case_number, :output
      def initialize(case_number,options)
        @options = options
        @output = $stdout
        @case_number = case_number
        config.read if config.exist?
      end

      def execute
        if get_psi_note_path.nil?
          answer = prompt.select('You have not set a working path for psi_notes', ['Create one for me', 'I will provide a path'])
          if answer == 'Create one for me'
              set_path("#{Dir.home}/psi_notes_erptool")
          else
            path_to_link = prompt.ask('path to link: ')
            set_path(path_to_link)
          end
          create_psi_notes(get_psi_note_path)
        # if options[:init] || options[:init] && case_number.empty?
        #   init_flag_used
        # elsif options[:link] || options[:link]  && case_number.empty?
        #   link_flag_used
        # else
        #   # create dir in working path
        #   # run bundle init and use gemspec file created when path was set
        #   # propmpt user with psi questions
        #   # create rb file and fill out questions in file 
        #   File.new("#{get_psi_note_path}/psi_notes_erptool/#{case_number}.rb", "w")
        #   output.puts "Generated file for case number #{case_number}"
        # end
        end
        File.new("#{get_psi_note_path}/#{case_number}.rb", "w")
      end

      def get_psi_note_path
        config.fetch('PSI_NOTES_PATH')
      end

      def path_already_set?(path)
        get_psi_note_path == path
      end

      def set_path(path)
        config.set('PSI_NOTES_PATH', value: path)
        config.write(force: true)
      end

      def create_psi_notes(path)
        Dir.mkdir("#{path}/psi_notes_erptool")
      end

      def init_flag_used
        # check if path exists already
        if get_psi_note_path
          if path_already_set?(Dir.home)
            return output.puts "psi_notes path already initialized"
          else
            will_overwrite = prompt.yes?("Preferred psi_notes path is set to: #{get_psi_note_path} \nDo you wish to overwrite?") # user wants to 'default' path 
            if will_overwrite
              set_path(Dir.home)
              # move or create logic?
              output.puts "Overwrote psi_notes path"
            end
          end
        else # user has never set a path
          set_path(Dir.home)
          create_psi_notes("#{get_psi_note_path}/psi_notes_erptool")
          # todo: create a .gemspec file in this working path
          f = generate_gemfile_template
          puts "Initialized a psi_notes directory!"
        end        
      end

      def link_flag_used
        unless path_already_set?(options[:link])
          set_path(options[:link])
          puts "Linked! Prefered psi_notes dir set to: #{options[:link]}"
        else
          return output.puts "psi_notes path already configured here" # path is already custom path
        end        
      end

      def generate_gemfile_template

      end


    end
  end
end
