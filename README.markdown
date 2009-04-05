# smoke

smoke is what comes from pipes. now I really sound like a crack head. 
more later.

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

    Smoke.join(:ruby, :python)
or even

    Smoke.join(:python, :ruby) do
      emit do
        sort :title
        rename :shit_name => :title
      end
    end
### Copyright

Copyright (c) 2009 Ben Schwarz. See LICENSE for details.
