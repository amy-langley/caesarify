require 'dotenv/load'
require 'optparse'
require 'pry'
require 'symbolized'

module Caesarify
  class OptionsError < StandardError; end

  class App
    attr_accessor :args

    def initialize(args)
      @args = SymbolizedHash.new args
      raise OptionsError.new("Please specify a workflow") unless App.valid_args? args
    end

    def go
    end

    def application_id
      ENV["APPLICATION_ID"]
    end

    def caesar_url
      ENV["CAESAR_URL"]
    end

    def oauth_secret
      ENV["CAESARIFY_OAUTH_SECRET"]
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
  end
end