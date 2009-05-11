module TestSource
  def self.source(name, &block)
    source = Smoke::Origin.new(name, &block || Proc.new {})
    source.items = [
      {:head => "Platypus"},
      {:head => "Kangaroo"}
    ]
    return source
  end
end