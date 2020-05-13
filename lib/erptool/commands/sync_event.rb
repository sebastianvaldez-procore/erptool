# frozen_string_literal: true

require_relative '../command'
require 'tty-config'
require 'pry-byebug'
require_relative '../services/auth_service'
require_relative '../services/sync_event_service'

module Erptool
  module Commands
    class SyncEvent < Erptool::Command
      attr_reader :action
      def initialize(action)
        @action = action
        config.read if config.exist?
      end

      def execute(input: $stdin, output: $stdout)
        case action
        when 'set_successful'
          #company id, procore_item_id
          data = prompt_user_for_sync_event_info
          token = AuthService.new(config).ensure_valid_token
          result = SyncEventService.new(data.merge!(token: token)).set_successful
          result
        when 'set_status'
          data = prompt_user_for_sync_event_info
          status_to_set = prompt.select('Set status to: ', ['ok', 'ready_to_export', 'in_progress', 'failed'])
          token = AuthService.new(config).ensure_valid_token
          result = SyncEventService.new(data.merge!(token: token)).set_status(status: status_to_set)
          result
        when ''
          output.puts 'You must pass in an action.'
          return
        end

        if result[:errors].any?
          output.puts "Update Failed: #{result[:errors]}"
        else
          output.puts 'Update Successful!'
        end
      end

      def prompt_user_for_sync_event_info
        #company id, procore_item_id
        prompt.collect do
          key(:company_id).ask('What is the Company id? ') do |q|
            q.validate(/\d+/, 'Company ID must exist and be an integer') 
          end

          key(:procore_item_id).ask('What is the Procore Item Id?') do |q|
            q.validate(/\d+/, 'Procore Item ID must exist and be an integer')
          end
        end        
      end

    end
  end
end
