require 'dotenv/load'
require 'optparse'
require 'panoptes-client'
require 'pry'
require 'symbolized'

module Caesarify
  class OptionsError < StandardError; end

  class FakePanoptes
    def method_missing(method_name, *args)
      Rails.logger.info(">>> Panoptes API call [#{method_name}], args: #{args.inspect}")
      nil
    end
  end

  class App
    attr_accessor :args

    def initialize(args)
      @args = SymbolizedHash.new args
      raise OptionsError.new("Please specify a workflow") unless App.valid_args? args
    end

    def go
      workflow = SymbolizedHash.new Caesarify::App.panoptes.workflow(workflow_id)
      puts extract_tasks workflow
    end

    def extract_tasks(workflow)
      workflow[:tasks].map do |task_key,task|
        config = {}
        config[:type] = task[:type]
        config[:tools] = if task.key?(:tools)
          task[:tools].map{ |tool| tool[:type] }
        else
          []
        end
        [task_key, config]
      end.to_h
    end

    def caesar_url
      ENV["CAESAR_URL"]
    end

    def panoptes_url
      ENV["PANOPTES_URL"]
    end

    def workflow_id
      args[:workflow_id]
    end

    def self.parse_arguments
      options = {}
      parser = OptionParser.new do |p|
        p.on('-w', '--w WORKFLOW_ID', 'The Panoptes id of the workflow to configure') do |v|
          options[:workflow_id] = v
        end
      end

      parser.parse!
      puts parser.help unless valid_args? options
    end

    def self.valid_args? args
      return false if args.nil?
      return false if args.empty?
      return false unless ((args.key?(:workflow_id) || args.key?("workflow_id")))
      true
    end

    def self.panoptes
      return @panoptes if @panoptes

      if ENV.key?("PANOPTES_CLIENT_ID")
        @panoptes = ::Panoptes::Client.new(env: "staging",
                                         auth: {client_id: ENV.fetch("PANOPTES_CLIENT_ID"),
                                                client_secret: ENV.fetch("PANOPTES_CLIENT_SECRET")},
                                                params: {:admin => true})
      else
        @panoptes = FakePanoptes.new
      end
    end

    def self.panoptes=(adapter)
      @panoptes = adapter
    end
  end
end