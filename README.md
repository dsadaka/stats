Onlife
=========

A small project that prints baseball statistics.

Though uncharacteristic of a Ruby on Rails app, this project does not run from a browser.
In accordance with the requirements, output should be sent to STDOUT instead.
Therefore, all user processes are implemented as rake tasks and run from the command line.

Ruby on Rails
---

This application was developed and tested with:

-   Ruby 2.1.1
-   Rails 4.1.6

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Database
---

This application uses SQLite with ActiveRecord.


Getting Started
---

### Install ruby 2.1.1 if you haven't already (using RVM)
1) Go to your top level development directory
2) rvm install ruby-2.1.1   # This will install 2.1.1 

NOTE: A great doc for installing ruby and rails is at

http://railsapps.github.io/installrubyonrails-ubuntu.html

### Copy down source
1) Go to your top level development directory<br />
2) git clone git@github.com:/dsadaka/stats.git   # Clone this repository<br />

### Finish installation
1) cd stats             # Clone command put source in stats subdir.  The gemset stats will get created if not already<br />
2) bundle install       # if you get any "could not find..." errors, just rm Gemfile.lock and try again<br />
3) rake db:migrate      # build tables<br />

#### Populate tables
##### Player Master table
rake stats:import_master             # Empties Master and Imports Master-small.csv (for non-default usage, see below)
##### Batting stats
rake stats:import_batting            # Empties Batting and Imports Batting-07-12.csv (for non-default usage, see below)

#### Run tests
1) cp db/development.sqlite3 db/test.sqlite3  # Just use copy of development data since read-only
2) rake test test/models/master_test.rb
3) rake test test/models/batting_test.rb

### Display Stats
rake stats:print

### That's it!

### Non default options

You can import csv files of other names and you can elect NOT to have the import routine empty the db table first.
You do so by passing the filename and a yes or no flag to the import.

Examples:
---------
rake stats:import_master\[More-players.csv,no\]   # Imports from a played named More-players.csv WITHOUT emptying Master first

rake stats:import_batting\[new-batting.csv,yes\]  # Imports batting stats from new-batting.csv after DELETING all records in Batting


Author
------

Dan Sadaka, Datakey, Inc.
North Miami Beach, FL 33162
(305) 999-0191
