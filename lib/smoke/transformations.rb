module Smoke
  module Transformations
    
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
  end
end