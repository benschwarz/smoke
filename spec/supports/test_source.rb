module TestSource
  def self.source(name, &block)
    source = Smoke::Origin.new(name, &block || Proc.new {})
    source.items = [
      {:head => "Animal: Platypus"},
      {:head => "Animal: Kangaroo"}
    ]
    return source
  end
end