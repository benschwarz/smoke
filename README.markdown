# smoke

smoke is a Ruby based DSL that allows you to take data from YQL, RSS / Atom (and more, if you think of a useful source).
This "data" can then be re-represented, sorted and filtered. You can collect data from a multiude of sources, sort them on a common property
and return a plain old ruby object or json (You could add in something to output XML too)


## The concept

The concept comes from using [Yahoo Pipes](http://pipes.yahoo.com) to make little mash ups, get a list of tv shows for my torrent client, compile a recipe book or make tools to give me a list of albums that artists in my music library are about to be release.

## How or what to contribute

* Test everything you do
* Add a source
* Add a way of transforming the output (filters: accept, deny. etc)
* Add a way to output (XML, anyone?)
* Examples of queries you'd like to be able to do

## API Examples
    # This will use yahoo search to get an array of search results about Ruby
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
