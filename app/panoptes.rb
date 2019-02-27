module Caesarify
  class App
    module Panoptes
      class FakePanoptes
        def method_missing(method_name, *args)
          Rails.logger.info(">>> Panoptes API call [#{method_name}], args: #{args.inspect}")
          nil
        end
      end
    end

    def extract_tasks(workflow)
      workflow[:tasks].map do |task_key,task|
        {}.tap do |config|
          config[:key] = task_key
          config[:type] = task[:type]
          config[:tools] = if task.key?(:tools)
            task[:tools].map{ |tool| tool[:type] }.uniq
          else
            []
          end
        end
      end
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