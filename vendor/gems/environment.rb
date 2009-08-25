# DO NOT MODIFY THIS FILE
module Bundler
  dir = File.dirname(__FILE__)

  ENV["GEM_HOME"] = dir
  ENV["GEM_PATH"] = dir
  ENV["PATH"]     = "#{dir}/../../bin:#{ENV["PATH"]}"
  ENV["RUBYOPT"]  = "-r#{__FILE__} #{ENV["RUBYOPT"]}"

  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/simple-rss-1.2/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/simple-rss-1.2/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/fakeweb-1.2.5/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/fakeweb-1.2.5/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/crack-0.1.1/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/crack-0.1.1/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/wycats-moneta-0.6.0/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/wycats-moneta-0.6.0/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/adamwiggins-rest-client-1.0.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/adamwiggins-rest-client-1.0.3/lib")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.1.3/bin")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.1.3/ext/json/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.1.3/ext")
  $LOAD_PATH.unshift File.expand_path("#{dir}/gems/json-1.1.3/lib")

  @gemfile = "#{dir}/../../Gemfile"

  require "rubygems"

  @bundled_specs = {}
  @bundled_specs["wycats-moneta"] = eval(File.read("#{dir}/specifications/wycats-moneta-0.6.0.gemspec"))
  @bundled_specs["wycats-moneta"].loaded_from = "#{dir}/specifications/wycats-moneta-0.6.0.gemspec"
  @bundled_specs["fakeweb"] = eval(File.read("#{dir}/specifications/fakeweb-1.2.5.gemspec"))
  @bundled_specs["fakeweb"].loaded_from = "#{dir}/specifications/fakeweb-1.2.5.gemspec"
  @bundled_specs["crack"] = eval(File.read("#{dir}/specifications/crack-0.1.1.gemspec"))
  @bundled_specs["crack"].loaded_from = "#{dir}/specifications/crack-0.1.1.gemspec"
  @bundled_specs["simple-rss"] = eval(File.read("#{dir}/specifications/simple-rss-1.2.gemspec"))
  @bundled_specs["simple-rss"].loaded_from = "#{dir}/specifications/simple-rss-1.2.gemspec"
  @bundled_specs["json"] = eval(File.read("#{dir}/specifications/json-1.1.3.gemspec"))
  @bundled_specs["json"].loaded_from = "#{dir}/specifications/json-1.1.3.gemspec"
  @bundled_specs["adamwiggins-rest-client"] = eval(File.read("#{dir}/specifications/adamwiggins-rest-client-1.0.3.gemspec"))
  @bundled_specs["adamwiggins-rest-client"].loaded_from = "#{dir}/specifications/adamwiggins-rest-client-1.0.3.gemspec"

  def self.add_specs_to_loaded_specs
    Gem.loaded_specs.merge! @bundled_specs
  end

  def self.add_specs_to_index
    @bundled_specs.each do |name, spec|
      Gem.source_index.add_spec spec
    end
  end

  add_specs_to_loaded_specs
  add_specs_to_index

  def self.require_env(env = nil)
    context = Class.new do
      def initialize(env) @env = env ; end
      def method_missing(*) ; end
      def gem(name, *args)
        opt = args.last || {}
        only = opt[:only] || opt["only"]
        except = opt[:except] || opt["except"]
        files = opt[:require_as] || opt["require_as"] || name

        return unless !only || [only].flatten.any? {|e| e.to_s == @env }
        return if except && [except].flatten.any? {|e| e.to_s == @env }

        files.each { |f| require f }
        yield if block_given?
        true
      end
    end
    context.new(env && env.to_s).instance_eval(File.read(@gemfile))
  end
end

module Gem
  def source_index.refresh!
    super
    Bundler.add_specs_to_index
  end
end
