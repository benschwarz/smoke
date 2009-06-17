module Smoke
  class Origin
    attr_reader :items
    attr_accessor :name
    
    def initialize(name, &block)
      raise StandardError, "Sources must have a name" unless name
      @name = name
      @items, @prepare, @transformation = [], [], []

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
      output = (@items.length == 1) ? @items.first : @items
      
      case type
      when :json
        return ::JSON.generate(output)
      when :yaml
        return YAML.dump(output)
      else
        return output
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
      
      return self
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
      @prepare << block
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
    def sort(key)
      @items = @items.sort_by{|i| i[key] }
    rescue NoMethodError => e
      Smoke.log.info "You're trying to sort by \"#{key}\" but it does not exist in your item set"
    ensure
      return self
    end
    
    # Reverse the order of the items
    # 
    # Usage
    #   Smoke[:ruby].ouput
    # Returns [{:header => "Platypus"}, {:header => "Kangaroo"}]
    #   Smoke[:ruby].reverse.output
    # Returns [{:header => "Kangaroo"}, {:header => "Platypus"}]
    def reverse
      @items.reverse!
      return self
    end

    # Keep items that match the regex
    # 
    # Usage (chained): 
    #     Smoke[:ruby].keep(:title, /tuesday/i)
    # Usage (block, during initialization):
    #     Smoke.yql(:ruby) do
    #       ...
    #       keep(:title, /tuesday/i)
    #     end
    def keep(key, matcher)
      @items.reject! {|i| (i[key] =~ matcher) ? false : true }
      return self
    end

    # Discard items that do not match the regex
    # 
    # Usage (chained): 
    #     Smoke[:ruby].discard(:title, /tuesday/i)
    # Usage (block, during initialization):
    #     Smoke.yql(:ruby) do
    #       ...
    #       discard(:title, /tuesday/i)
    #     end
    def discard(key, matcher)
      @items.reject! {|i| (i[key] =~ matcher) ? true : false }
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
    
    private
    def prepare!
      @prepare.each{|p| p.call } unless @prepare.nil?
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