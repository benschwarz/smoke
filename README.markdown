# smoke

smoke is a Ruby based DSL that allows you to query web services such as YQL, RSS / Atom and JSON or XML in an elegant manner.

These "services" can then be re-represented, sorted and filtered. Data can be collected from multiple sources, sorted via a common property, chopped up and refried. 

Then you can output as a plain ruby object (or JSON)

## Examples of use

* The `examples` directory has something to get you running straight away
* I powered [my entire site](http://www.germanforblack.com) [using smoke](http://github.com/benschwarz/benschwarz-site/blob/44de70463c744d821d3ffd2cf940e6d3e415fbdd/lib/stream.rb), until further documentation exists, this is probably a good place to start.
* Read further details in the [rdoc documentation](http://rdoc.info/projects/benschwarz/smoke) or [the wiki](http://wiki.github.com/benschwarz/smoke)

## Media

* [Presentation from Melbourne #roro](http://www.slideshare.net/benschwarz/smoke-1371124)
* Early [screencast](http://vimeo.com/4272804) to get developer / peer feedback


## The concept

The concept comes from using [Yahoo Pipes](http://pipes.yahoo.com) to make web based mash ups: Get a list of tv shows for my torrent client, compile a recipe book or make tools to give me a list of albums that artists in my music library are about to be released.

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
* Document all sources with their irrespective differential methods
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
