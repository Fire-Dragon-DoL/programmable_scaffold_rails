# ProgrammableScaffoldRails

This gem should remove repeated code when rails scaffolding, expecially on controllers.  
It's useful when you are prototyping and when you are just building an application with a lot of simple **CRUD**.  
It's also configurable, to avoid as most as possible to completely override one of the default controllers method, unless you are doing something really special.

## Installation

Add this line to your application's Gemfile:

    gem 'programmable_scaffold_rails', '~> 0.0.1'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install programmable_scaffold_rails

## Usage

TODO: Write usage instructions here
In your Controller (or in ApplicationController) include the module:

    include ProgrammableScaffoldRails::ActionControllerExtensions

It has friendly_id support

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
