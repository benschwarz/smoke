# smoke

## Usage

### Making your own little search engine

    Smoke.yql(:ruby) do
      select  :all
      from    "search.web"
      where   :query, "ruby"
    end

Now you have items that are matching ruby!

### API

#### Rename methods

##### Single
    rename(:content).to(:title)

##### Multiple
    rename(:content, :href).to(:title, :link)

### Copyright

Copyright (c) 2009 Ben Schwarz. See LICENSE for details.
