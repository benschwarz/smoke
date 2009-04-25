module Smoke
  module Source # :nodoc:
    module YQL # :nodoc:
      Smoke.register(Smoke::Source::YQL)
      
      def yql(name, &block)
        YQL.new(name, &block)
      end
      
      # YQL will call to Yahoo YQL services
      #
      # Usage:
      #   Smoke.yql(:ruby) do
      #     select  :all
      #     from    "search.web"
      #     where   :query, "ruby"
      #   end
      class YQL < Origin
        attr_reader :request
        
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
        # or
        #   where :query, "python"
        def where(column, value)
          @where = @where || []
          @where << "#{column.to_s} = '#{value}'"
        end
        
        def dispatch
          @request = Smoke::Request.new(build_uri)
          self.items = @request.body[:query][:results][:result]
        end
        private
        
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
