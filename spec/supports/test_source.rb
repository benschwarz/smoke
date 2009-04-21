module TestSource
  def self.source(name, &block)
    source = Smoke::Origin.allocate
    source.stub!(:dispatch)
    source.send(:initialize, name, &block || Proc.new {})
    source.items = [
      {:head => "Platypus"},
      {:head => "Kangaroo"}
    ]
    return source
  end
end