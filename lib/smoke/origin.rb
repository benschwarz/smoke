module Smoke
  class Origin
    attr_reader :items
    attr_accessor :name
    
    def initialize(name, &block)
      raise StandardError, "Sources must have a name" unless name
      @name = name
      @items, @transformation = [], []

      activate!
      instance_eval(&block) if block_given?
    end
    
    # Output your items in a range of formats (:ruby, :json and :yaml currently)
    # Ruby is the default format and will automagically yielded from your source
    #
    # Usage
    # 
    #   output(:json)
    #   => "[{title: \"Ray\"}, {title: \"Peace\"}]"
    def output(type = :ruby)
      prepare!
      dispatch if respond_to? :dispatch
      
      case type
      when :json
        return ::JSON.generate(@items)
      when :yaml
        return YAML.dump(@items)
      else
        return @items
      end      
    end
    
    def items=(response) # :nodoc:
      @items = [(@path.nil?) ? response : drill(response, *@path)]
      symbolize_keys!
      transform!
    end
    
    # Path allows you to traverse the tree of a the items returned to 
    # only give you access to what you're interested in.
    #
    # Usage:
    # path :down, :to, :the, :data
    # 
    # Will traverse through a tree as follows:
    #
    #   {
    #     :down => {
    #       :to => {
    #         :the => {
    #           :data => []
    #         }
    #       }
    #     }
    #   }
    #
    # You will need to help smoke find an array of 
    # items that you're interested in. 
    def path(*path)
      @path = path
    end
    
    # Transform each item
    #
    # Usage:
    #   emit do
    #     rename(:href => :link)
    #   end 
    def emit(&block)
      raise ArgumentError, "requires a block" unless block_given?
      @transformation << block
    end
    
    # Transform must be used inside an `emit` block.
    # It can be used to alter named keys within the item set
    #
    # Usage:
    #     emit do
    #       transform :name, :description do |name|
    #         name.gsub(/\302/, "")
    #       end
    #     end
    #
    # In quasi-english: The result of the block is returned and set to each 
    # of the :name and :description keys in the result set.
    def transform(*keys)
      raise ArgumentError, "requires a block" unless block_given?
      keys.each do |key|
        items.each do |item|
          item[key] = yield(item[key]) || item[key]
        end
      end
    end
    
    # Insert must be used inside an `emit` block.
    # It can be used to insert named keys to all items within the result set
    # 
    # Usage: 
    #   
    #   emit do
    #     insert :source, "twitter"
    #   end
    # 
    # Once output is called, all items will contain a key of :source with
    # a value of "twitter"
    def insert(key, value)
      @items.each do |item|
        item[key] = value
      end
    end

    # Prepare is used when you'd like to provision for 
    # arguments / variables to be set after the source definition.
    # Eg, create a source definition for twitter, omitting the "username".
    # Set the username using chaining later.
    # 
    # Usage:
    #   # Definition
    #   Smoke.feed :twitter do
    #     prepare do
    #       url "http://twitter.com/#{username}/rss"
    #     end
    #   end
    #   
    #   # End use
    #   Smoke[:twitter].username(:benschwarz).output
    def prepare(&block)
      raise ArgumentError, "requires a block" unless block_given?
      @prepare = block
    end
    
    def method_missing(symbol, *args, &block)
      ivar = "@#{symbol}"
      
      if args.empty?
        return instance_variable_get(ivar) || super  
      else
        instance_variable_set(ivar, args.pop)
      end

      return self
    end

    # Re-sort items by a particular key
    # Sort must be used inside an `emit` block.
    def sort(key)
      @items = @items.sort_by{|i| i[key] }
    rescue NoMethodError => e
      Smoke.log.info "You're trying to sort by \"#{key}\" but it does not exist in your item set"
    end
    
    # Reverse the order of the items
    # 
    # Usage
    #   Smoke[:ruby].output
    # Returns [{:header => "Platypus"}, {:header => "Kangaroo"}]
    #   Smoke.yql(:ruby) do
    #     ... Define your source
    #     emit do
    #       reverse
    #     end
    #   end
    # Returns [{:header => "Kangaroo"}, {:header => "Platypus"}]
    # Reverse must be used inside an `emit` block.
    def reverse
      @items.reverse!
    end

    # Keep items that match the regex
    # 
    # Usage (block, during initialization):
    #     Smoke.yql(:ruby) do
    #       ...
    #       emit do
    #         keep(:title, /tuesday/i)
    #       end
    #     end
    # Keep must be used inside an `emit` block.
    def keep(key, matcher)
      @items.reject! {|i| (i[key] =~ matcher) ? false : true }
    end

    # Discard items that do not match the regex
    # 
    # Usage (block, during initialization):
    #     Smoke.yql(:ruby) do
    #       ...
    #       emit do
    #         discard(:title, /tuesday/i)
    #       end
    #     end
    # Discard must be used inside an `emit` block.
    def discard(key, matcher)
      @items.reject! {|i| (i[key] =~ matcher) ? true : false }
    end

    # Rename one or many keys at a time
    #
    # Usage
    #   # Renames all items with a key of href to link
    #   rename(:href => :link)
    # or
    #   rename(:href => :link, :description => :excerpt)
    # Rename must be used inside an `emit` block.
    def rename(*args)
      @items.each {|item| item.rename(*args) }
    end

    # Truncate your result set to this many objects
    #
    # Usage
    #   Smoke.yql(:ruby) do
    #     ...
    #     truncate(3)
    #   end
    #   Smoke[:ruby].output
    #   => [{title => "Canon"}, {:title => "Nikon"}, {:title => "Pentax"}]
    # Truncate must be used inside an `emit` block.
    def truncate(length)
      @items = @items[0..(length - 1)]
    end
    
    private
    def prepare!
      @prepare.call unless @prepare.nil?
    end
    
    def transform!
      @transformation.each{|t| t.call } unless @transformation.nil?
    end
    
    def symbolize_keys!
      @items = items.flatten.map{|i| i.symbolize_keys! } if items.respond_to? :flatten
    end
    
    def drill(*path)
      path.inject(nil) do |obj, pointer|
        obj = obj.nil? ? pointer : obj[pointer]
      end
    end
    
    def activate!
      Smoke.activate(@name, self)
    end
  end
end

Dir["#{File.dirname(__FILE__)}/source/*.rb"].each &method(:require)