# smoke

## Usage

### YQL (You have a yql url from yahoo and want to weed it down to something usable)

    yql "http://path/to/yahoo-yql" do
      
    end
### API

#### Rename methods

##### Single
    rename(:content).to(:title)

##### Multiple
    rename(:content, :href).to(:title, :link)

### Copyright

Copyright (c) 2009 Ben Schwarz. See LICENSE for details.
