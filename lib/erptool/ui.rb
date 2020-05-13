require 'forwardable'

module ErpTool
  class UI
    extend Forwardable
       
    def initialize(prompt)
      @prompt = prompt
      @quite = false
      @debug = ENV['DEBUG']
      @shell = Thor::Shell::Basic.new
    end

    def confirm(message)
      @prompt.ok(message)
    end

    def info(message)
      @prompt.say(message)
    end

  end
end