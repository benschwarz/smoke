module Smoke
  module Source
    module YQL
      Smoke.register(Smoke::Source::YQL)
      
      def yql(name, &block)
        YQL.new(name, &block)
      end
      
      class YQL < Source
        attr_reader :name, :request
        
        # Usage:
        #   Smoke.yql(:ruby) do
        #     select  :all
        #     from    "search.web"
        #     where   :query, "ruby"
        #   end
        def initialize(name, &block)
          super
        end
        
        # Select indicates what YQL will be selecting
        # Usage:
        #   select :all
        #   => "SELECT *"
        #   select :title
        #   => "SELECT title"
        #   select :title, :description
        #   => "SELECT title, description"
        def select(what)
          @select = what.join(",") and return if what.is_a? Array
          @select = "*" and return if what == :all
          @select = what.to_s
        end
        
        # from corresponds to the from fragment of the YQL query
        # Usage: 
        #   from "search.web"
        # or
        #   from :html
        def from(source)
          @from = source.join(',') and return if source.is_a? Array
          @from = source.to_s
        end
        
        # where is a straight up match, no fancy matchers
        # are currently supported
        # Usage:
        #   where :xpath, "//div/div/a"
        def where(column, value)
          @where = @where || []
          @where << "#{column.to_s} = '#{value}'"
        end
        
        private
        def dispatch
          @request = Smoke::Request.new(build_uri)
          define_items @request.body[:query][:results][:result]
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