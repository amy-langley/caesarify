require 'dotenv/load'
require 'optparse'
require 'symbolized'

module Caesarify
  class ConfigurationError < StandardError; end

  class App
    attr_accessor :args

    def initialize(args)
      @args = SymbolizedHash.new args
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
      args["workflow_id"]
    end

    def self.parse_arguments
      options = {}
      OptionParser.new do |parser|
        parser.on('-w', '--w WORKFLOW_ID', 'The Panoptes id of the workflow to configure') do |v|
          options["workflow_id"] = v
        end
      end
    end
  end
end