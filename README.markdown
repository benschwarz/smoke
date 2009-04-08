# smoke

smoke is what comes from pipes. now I really sound like a crack head. 
more later.

### Not ready for consumption



## API
    Smoke.yql(:ruby) do
      select  :all
      from    "search.web"
      where   :query, "ruby"
    end

    Smoke.yql(:python) do
      select  :all
      from    "search.web"
      where   :query, "python"
    end

### Soon, not yet
    Smoke.join(:ruby, :python)
or even

    Smoke.join(:python, :ruby) do
      emit do
        sort :title
        rename :shit_name => :title
      end
    end

### TODO (working on, just mental notes)

* Write a joiner source into the Smoke namespace
* Consider invokation methods (registering of sources, namespacing et al)

### Copyright

Copyright (c) 2009 Ben Schwarz. See LICENSE for details.
