module TestSource
  def self.source(name, &block)
    source = Smoke::Origin.allocate
    source.stub!(:dispatch)
    source.send(:define_items, [
      {
        :head => "Platypus"
      },
      {
        :head => "Kangaroo"
      }
    ])
        
    source.send(:initialize, name, &block || Proc.new {})
    return source
  end
end