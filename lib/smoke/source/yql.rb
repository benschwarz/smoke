module Smoke
  module Sources
    module YQL
      Smoke::Source.register(Smoke::Sources::YQL)
      
      def yql(url, opts = {}, &block)
        YQL.new(url, opts, &block)
      end
      
      class YQL < Smoke::Source
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