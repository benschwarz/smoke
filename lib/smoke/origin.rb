module Smoke
  class Origin
    attr_reader :items, :name
    
    def initialize(name, &block)
      raise StandardError, "Sources must have a name" unless name
      @name = name
      @items = []
      activate!
      instance_eval(&block) if block_given?
    end
    
    include Transformations
    
    # Output your items in a range of formats (:ruby, :json and :yaml currently)
    # Ruby is the default format and will automagically yielded from your source
    #
    # Usage
    # 
    #   output(:json)
    #   => "[{title: \"Ray\"}, {title: \"Peace\"}]"
    def output(type = :ruby)
      dispatch if respond_to? :dispatch
      
      case type
      when :ruby
        return @items
      when :json
        return ::JSON.generate(@items)
      when :yaml
        return YAML.dump(@items)
      end
    end
    
    def items=(items) # :nodoc:
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