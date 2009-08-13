class Dep
  class Dependency
    attr :name
    attr :version
    attr :environment
    attr :url

    def initialize(name, version = nil, environment = nil, url = nil)
      @name = name
      @version = version if version && !version.empty?
      @environment = environment ? environment.split(/\, ?/) : []
      @url = url
    end

    def for_environment?(env)
      environment.empty? || environment.include?(env)
    end

    def version_number
      version[/([\d\.]+)$/, 1]
    end

    def vendor_name
      version ? "#{name}-#{version_number}" : name
    end

    def vendor_path
      Dir[File.join("vendor", "#{vendor_name}*", "lib")].first ||
        Dir[File.join("vendor", name, "lib")].first
    end

    def require_vendor
      $:.unshift(File.expand_path(vendor_path)) if vendor_path
    end

    def require_gem
      return unless defined?(Gem)

      begin
        gem(*[name, version].compact)
        true
      rescue Gem::LoadError => e
        false
      end
    end

    def require
      require_vendor || require_gem
    end

    def to_s
      [name, version, ("(#{environment.join(", ")})" unless environment.empty?)].compact.join(" ")
    end
  end

  include Enumerable

  attr :dependencies

  def initialize(dependencies)
    @dependencies = []
    @missing = []

    dependencies.each_line do |line|
      next unless line =~ /^([\w\-_]+) ?([<~=> \d\.]+)?(?: \(([\w, ]+)\))?(?: ([a-z]+:\/\/.+?))?$/
      @dependencies << Dependency.new($1, $2, $3, $4)
    end
  end

  def filter(environment)
    @dependencies.select do |dep|
      dep.for_environment?(environment)
    end
  end

  def require(environment)
    filter(environment).each do |dep|
      @missing << dep unless dep.require
    end

    if !@missing.empty?
      $stderr.puts "\nMissing dependencies:\n\n"

      @missing.each do |dep|
        $stderr.puts "  #{dep}"
      end

      $stderr.puts
      $stderr.puts "Run `dep list` to view missing dependencies or `dep vendor --all` if you want to vendor them.\n\n"
      exit(1)
    end

    $:.unshift File.expand_path("lib")
  end

  def each(&block)
    @dependencies.each(&block)
  end
end
