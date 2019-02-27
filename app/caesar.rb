require 'faraday'

module Caesarify
  class App
    module Caesar
      class FakeCaesar
        def method_missing(method_name, *args)
          logger.info(">>> Caesar API call [#{method_name}], args: #{args.inspect}")
          nil
        end
      end

      def create_workflow(workflow_id)
        # Caesar.client.get('/workflows/121')
      end

      def create_extractor(workflow_id, task)
        puts task
      end

      def create_reducer(workflow_id, task)
      end

      def self.client
        @client ||= Faraday.new(url: ENV['CAESAR_URL']) do |faraday|
          faraday.adapter Faraday.default_adapter # WITHOUT THIS LINE NOTHING WILL HAPPEN

          faraday.request :panoptes_client_credentials, url: ENV['CAESAR_URL'], client_id: ENV['PANOPTES_CLIENT_ID'], client_secret: ENV['PANOPTES_CLIENT_SECRET']
          # faraday.request :panoptes_api_v1
          faraday.response :json
        end
      end

      def self.client=(new_client)
        @client = new_client
      end
    end
  end
end