require 'fastercsv'

module Smoke
  # Usage:
  #   Smoke.csv(:asx_listed_companies) do
  #     url "http://www.asx.com.au/asx/research/ASXListedCompanies.csv", :header_row => 3
  #   end
  class CSV < Origin
    attr_reader :request
    
    # The URL that you'd like smoke to source its data from
    # You can also set the type for silly servers that don't set a correct content-type (Flickr!)
    # Example:
    #   url "http://site.com/resource.json", :type => :json
    def url(source_url, options = {})
      @url, @options = source_url, options
    end
    
    protected
    def dispatch        
      @request = Smoke::Request.new(@url, @options)
      self.items = parse_csv
    end
    
    private
    
    def symbolize_key(string)
      string.gsub(/\s+/, "_").downcase.to_sym
    end
    
    def parse_csv
      parsed_csv = FasterCSV.parse(@request.body)
      items = []
      header = parsed_csv.slice!(0, (@options[:header_row] || 1)).last
      parsed_csv.each do |row|
        obj = {}
        header.each_with_index do |col, header_index|
          obj[symbolize_key(header[header_index])] = row[header_index]
        end
        items << obj
      end
      items
    end
    
  end
end
