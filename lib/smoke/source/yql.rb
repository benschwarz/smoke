module Smoke
  module Source
    module YQL
      Smoke.register(Smoke::Source::YQL)
      
      def yql(name, opts = {}, &block)
        YQL.new(name, opts, &block)
      end
      
      class YQL < Source
        attr_reader :name, :request
      
        def initialize(name, opts, &block)
          self.instance_eval(&block)
          dispatch
        end
        
        def select(what)
          @select = what.join(",") and return if what.is_a? Array
          @select = "*" and return if what == :all
          @select = what.to_s
        end
        
        def from(source)
          @from = source.join(',') and return if source.is_a? Array
          @from = source.to_s
        end
        
        def where(column, value)
          @where = @where || []
          @where << "#{column.to_s} = '#{value}'"
        end
        
        private
        def dispatch
          @request = Smoke::Request.new(build_uri)
          @items = @request.body[:query][:results][:result]
        end
        
        def build_uri
          "http://query.yahooapis.com/v1/public/yql?q=#{build_query}&format=json"
        end
        
        def build_query
          URI.encode("SELECT #{@select} FROM #{@from} WHERE #{@where.join(" AND ")}")
        end
      end
    end
  end
end