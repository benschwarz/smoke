module Smoke
  module Source
    module YQL
      Smoke.register(Smoke::Source::YQL)
      
      def yql(name, opts = {}, &block)
        YQL.new(name, opts, &block)
      end
      
      class YQL
        attr_reader :url
      
        def initialize(url, opts, &block)
          @url = url
          @request = Smoke::Request.new(build_uri)
          self.instance_eval(&block)
        end
        
        def xpath(path)
          @xpath = path
        end
        
        private
        def build_uri
          uri = [@url]
          uri << @xpath unless @xpath.nil?
        end
      end
    end
  end
end