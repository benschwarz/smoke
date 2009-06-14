module TestSource
  def self.source(name, &block)
    source = Smoke::Origin.new(name, &block)
    source.items = [
      {:head => "Animal: Platypus", :name => "Peter"},
      {:head => "Animal: Kangaroo", :name => "Kelly"}
    ]
    return source
  end
end