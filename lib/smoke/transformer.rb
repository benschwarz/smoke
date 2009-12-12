module Smoke
  # A class that will either transfer objects from Ruby to another format
  # or it will parse objects into Ruby. (JSON, XML & Yaml)
  class Transformer
    extend Registry
  end
end
