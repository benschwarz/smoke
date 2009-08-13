Dependencies
============

A simple way to express, manage and require your dependencies in Ruby.

Description
-----------

Dependencies allows you to declare the list of libraries your application needs
with a simple, readable syntax. It comes with a handy command line
tool for inspecting and vendoring your dependencies.

Usage
-----

Declare your dependencies in a `dependencies` file in the root of your project:

    rack ~> 1.0
    sinatra
    webrat (test) git://github.com/brynary/webrat.git
    quietbacktrace ~> 0.1
    contest ~> 0.1 (test)
    haml ~> 2.0
    rack-test 0.3 (test)
    faker ~> 0.3
    spawn ~> 0.1
    ohm git://github.com/soveran/ohm.git

Now you can try the `dep` command line tool to check your dependencies:

    $ dep list

You can specify an environment to see if requirements are met:

    $ dep list test

The above is `RACK_ENV`-aware.

Vendoring libraries
-------------------

In order to vendor a library you're using, simply:

    $ dep vendor haml

If the dependency is expressed with a version number, it will be vendored using
`gem unpack`. Otherwise, it will try to clone from a Git repository.

It's common to vendor everything when you start a new project. Try this:

    $ dep vendor --all

Loading dependencies in your project
------------------------------------

Dependencies doesn't assume you want to use RubyGems, so you're in charge of
requiring it before requiring `dependencies` (in Ruby 1.9 you're cornered – there's
no way out).

    # init.rb
    require "rubygems"
    require "dependencies"

That will work as long as RubyGems is available and you have Dependencies installed.
If a dependency is not found in `./vendor`, a call to `#gem` will be made.

Another option is to vendor Dependencies itself:

    # init.rb
    require "vendor/dependencies/lib/dependencies"

After that, all your `lib` directories below `./vendor` will be available in the `$LOAD_PATH`.

Additionally, Dependencies will leave your `./lib` in the `$LOAD_PATH`.

Benefits
--------

1. Documentation. It's a text file any team member can read to see what the project depends on.
2. Early failure. If a dependency is not met, the program terminates with a polite message inviting you to install the missing dependencies.
3. Vendorability (™). Easily vendor everything for self-contained applications.
4. Simplicity. It's a very lightweight tool. It won't do everything, but it's simple and works very well for us.

Installation
------------

    $ sudo gem install dependencies

License
-------

Copyright (c) 2009 Damian Janowski

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
