class DelayedBlock # :nodoc:
  def initialize(&block)
    @block = block
  end

  def execute!
    @block.call
  end
end