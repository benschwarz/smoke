# smoke

smoke is a Ruby based DSL that allows you to take data from YQL, RSS / Atom (and more, if you think of a useful source).
This "data" can then be re-represented, sorted and filtered. You can collect data from a multiude of sources, sort them on a common property
and return a plain old ruby object or json (You could add in something to output XML too)

In an early attempt to get feedback I created [this screencast](http://vimeo.com/4272804). I will do another once the library becomes closer to 1.0.0.

## The concept

The concept comes from using [Yahoo Pipes](http://pipes.yahoo.com) to make little mash ups, get a list of tv shows for my torrent client, compile a recipe book or make tools to give me a list of albums that artists in my music library are about to be release.

## How or what to contribute

* Test everything you do
* Add a source (I was thinking a source that took simply took a url and parsed whatever it got)
* Add a way to output (XML, anyone?)
* Examples of queries you'd like to be able to do

## API Examples
### YQL
    # This will use yahoo search to get an array of search results about Ruby
    Smoke.yql(:ruby) do
      select  :all
      from    "search.web"
      where   :query, "ruby"
      
      discard :title, /tuesday/i
    end

    Smoke.yql(:python) do
      select  :all
      from    "search.web"
      where   :query, "python"
    end

### Join sources and use them together
    Smoke.join(:ruby, :python)

or even

    Smoke.join(:python, :ruby) do
      emit do
        sort :title
        rename :shit_name => :title
      end
    end

### CI

Integrity [is running for smoke](http://integrity.ffolio.net/smoke)


### TODO (working on, just mental notes)

* Look at moving object transformations into the origin class
* Allow for sources to explicitly set the content type being returned for those stupid content providers
* Consider invokation methods (registering of sources, namespacing et al)
* YQL Definitions
* YQL w/oAuth
* YQL Subqueries?

### Copyright

Copyright (c) 2009 Ben Schwarz. See LICENSE for details.
