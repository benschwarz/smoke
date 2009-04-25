module Smoke
  class Origin
    attr_reader :items, :name
    
    def initialize(name, &block)
      raise StandardError, "Sources must have a name" unless name
      @name = name
      @items = []
      activate!
      instance_eval(&block) if block_given?
      dispatch if respond_to? :dispatch
    end
    
    # Transform each item
    #
    # Usage:
    #   emit do
    #     rename(:href => :link)
    #   end 
    def emit(&block)
      (@transformations ||= []) << DelayedBlock.new(&block)
    end

    # Re-sort items by a particular key
    def sort(key)
      @items = @items.sort_by{|i| i[key] }
    rescue NoMethodError => e
      Smoke.log.info "You're trying to sort by \"#{key}\" but it does not exist in your item set"
    ensure
      return self
    end
    
    # Rename one or many keys at a time
    # Suggested that you run it within an each block, but it makes no difference
    # other than readability
    #
    # Usage
    #   # Renames all items with a key of href to link
    #   rename(:href => :link)
    # or
    #   rename(:href => :link, :description => :excerpt)
    def rename(*args)
      @items.each {|item| item.rename(*args) }
      return self
    end
    
    # Output your items in a range of formats (ruby and json currently)
    # Ruby is the default format and will automagically yielded from your source
    #
    # Usage
    # 
    #   output(:json)
    #   => "[{title: \"Ray\"}, {title: \"Peace\"}]"
    def output(type = :ruby)
      case type
      when :ruby
        return @items
      when :json
        return ::JSON.generate(@items)
      end
    end
    
    # Truncate your result set to this many objects
    #
    # Usage
    #
    #   truncate(3).output
    #   => [{title => "Canon"}, {:title => "Nikon"}, {:title => "Pentax"}]
    def truncate(length)
      @items = @items[0..(length - 1)]
      return self
    end
    
    def items=(items)
      @items = items.map{|i| i.symbolize_keys! }
      invoke_transformations
    end
    
    private
    def invoke_transformations
      @transformations.each{|t| t.execute! } unless @transformations.nil?
    end
    
    def activate!
      Smoke.activate(name, self)
    end
  end
end

Dir["#{File.dirname(__FILE__)}/source/*.rb"].each &method(:require)