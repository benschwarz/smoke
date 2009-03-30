Dir["source/*.rb"].each &method(:require)

module Smoke
  module Source
    class << self
      def register(mod)
        class_eval { include mod }
      end
    end
  end
end