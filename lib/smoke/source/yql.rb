module Smoke
  # YQL will call to Yahoo YQL services
  #
  # Usage:
  #   Smoke.yql(:ruby) do
  #     select  :all
  #     from    "search.web"
  #     where   :query, "ruby"
  #   end
  class YQL < Origin
    API_BASE = "http://query.yahooapis.com/v1/public/yql"
    attr_reader :request
    
    # Select indicates what YQL will be selecting
    # Usage:
    #   select :all
    #   => "SELECT *"
    #   select :title
    #   => "SELECT title"
    #   select :title, :description
    #   => "SELECT title, description"
    def select(what = :all)
      @select = what.join(",") and return if what.is_a? Array
      @select = "*" and return if what == :all
      @select = what and return
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
      (@where||=[]) << "#{column.to_s} = '#{value}'"
    end
    
    # `use` can be used to set the url location of the data-table
    # that you want YQL to search upon
    #
    # Usage:
    #   use "http://datatables.org/alltables.env"
    def use(url)
      params.merge!({:env => url})
    end
    
    protected
    def params 
      @params || @params = {}
    end
    
    def dispatch
      @request = Smoke::Request.new(build_uri)
      self.items = @request.body
    end
    
    private
    def build_uri
      chunks = []
      default_opts = {
        :q => build_query,
        :format => "json"
      }.merge(params).each {|k,v| chunks << "#{k}=#{v}" }
      
      return URI.encode(API_BASE + "?" + chunks.join("&"))
    end
    
    def build_query
      "SELECT #{@select} FROM #{@from} WHERE #{@where.join(" AND ")}"
    end
  end
end
