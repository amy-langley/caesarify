require 'dotenv/load'
require 'optparse'
require 'panoptes-client'
require 'pry'
require 'symbolized'

require './app/caesar'
require './app/config'
require './app/panoptes'

module Caesarify
  class OptionsError < StandardError; end

  class App
    attr_accessor :args

    include Caesarify::App::Caesar
    include Caesarify::App::Config
    include Caesarify::App::Panoptes

    def initialize(args)
      @args = SymbolizedHash.new args
      raise OptionsError.new("Please specify a workflow") unless App::Config.valid_args? args
    end

    def go
      panoptes_workflow = SymbolizedHash.new Caesarify::App.panoptes.workflow(workflow_id)
      tasks = extract_tasks panoptes_workflow

      create_workflow(workflow_id)
      tasks.map do |task|
        create_extractor(workflow_id, task)
        create_reducer(workflow_id, task)
      end
    end
  end
end