# smoke

smoke is a Ruby based DSL that allows you to take data from YQL, RSS / Atom (and more, if you think of a useful source).
This "data" can then be re-represented, sorted and filtered. You can collect data from a multiude of sources, sort them on a common property
and return a plain old ruby object or json (You could add in something to output XML too)

## Media

* [Presentation from Melbourne #roro](http://www.slideshare.net/benschwarz/smoke-1371124)
* Early [screencast](http://vimeo.com/4272804) to get developer / peer feedback


## The concept

The concept comes from using [Yahoo Pipes](http://pipes.yahoo.com) to make little mash ups, get a list of tv shows for my torrent client, compile a recipe book or make tools to give me a list of albums that artists in my music library are about to be release.

## How or what to contribute

* Test everything you do
* Add a way to output (XML, anyone?)
* Examples of queries you'd like to be able to do (email / github message them to me)

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
    
### Define a source allowing for variables to be injected later

Source definition:

    Smoke.feed :delicious do
      prepare do
        url "http://feeds.delicious.com/v2/rss/#{username}?count=15"
      end
    end

Execution: 

    Smoke[:delicious].username("bschwarz").output
    
### CI

Integrity [is running for smoke](http://integrity.ffolio.net/smoke)


### TODO (working on, just mental notes)
#### Later / maybe
* YQL w/oAuth
* YQL Subqueries?
* Implement basic auth for sources


#### For wiki pages (docs, later)
* How to use `path`
* YQL Definitions
* Tranformations
* Insert
* Joining
* Variable injection
* Sort, Reverse
* Keep, Discard
* Truncate
* Manually setting the content type for a url

### Copyright

Copyright (c) 2009 Ben Schwarz. See LICENSE for details.
