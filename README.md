# ProgrammableScaffoldRails

This gem should remove repeated code when rails scaffolding, expecially on controllers.  
It's useful when you are prototyping and when you are just building an application with a lot of simple **CRUD**.  
It's also configurable, to avoid as most as possible to completely override one of the default controllers method, unless you are doing something really special.

## Installation

Add this line to your application's Gemfile:

    gem 'programmable_scaffold_rails', '~> 0.0.3'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install programmable_scaffold_rails

## Usage

In your Controller (or in ApplicationController if you want it application wise)
include the module:

```ruby
include ProgrammableScaffoldRails::ActionControllerExtensions
```

Now you have the class method `programmable_scaffold` available.  
This method should be run once per controller where you want to use it
(options are inherited and can be overridden!). It will create each required
action to have a controller working correctly like if just generated with rails scaffolding.
All options have already default values, you can call the method without passing anything to it.

If you want have an idea on how it's working, I suggest you to check the
[Rails application](https://github.com/Fire-Dragon-DoL/programmable_scaffold_rails/tree/master/spec/internal)
used internally for specs.

### Available options
| Name | Type | Default | Notes |
|------|------|---------|-------|
| class\_name | String | model class name | If set, replace the auto-calculated model class name |
| table\_name | String | tableized class name | This is used to name instance variables of a model, if set, it won't be auto-calculated |
| single\_instance\_name | String | singularized table name | Used when setting the instance variable for actions such as `new`, `edit`, `show`, `create`, `update` and `destroy` which can be used in the view |
| multiple\_instances\_name | String | pluralized table name | Used when setting the instance variable for action such as `index` which can be used in the view |
| cancan | bool | true | Enable cancan support which calls authorize! before each CRUD action |
| friendly\_id | bool | false | Enable `friendly_id` support, if your model uses `friendly_id`, that will be used for finding the model object |
| strong\_params | Symbol | :model_params | Name of existing method in controller, which should return params hash filtered by strong_parameters |
| url\_namespace | String | Empty string | When generating urls for `after_create_url`, `after_update_url` and `after_destroy_url`, a namespace will be prepended if this is set |
| after\_create\_action | Nil, Symbol | :show | One of `nil`, `:show`, `:edit`. `nil` and `:show` are the same |
| after\_update\_action | Nil, Symbol | :show | See `after_create_action` |
| after\_create\_url | Nil, Symbol, Proc, String | nil | If `nil` is set, the url will be auto generated with `url_namespace` and using the `after_create_action` for the given model object. If `Symbol` is used, a method with that name will be searched in controller and called with model instance as argument, it must generate a valid url. If proc is used, it will be called with model instance as argument. If a `String` is used, it will be directly passed to `url_for` to generate an url |
| after\_update\_url | Nil, Symbol, Proc, String | nil | See `after_create_url` |
| after\_destroy\_url | Nil, Symbol, Proc, String | nil | See `after_destroy_url` |
| formats | Array of Symbols | [ :html, :json ] | Formats returned by the CRUD actions for controller |

### Example

```ruby
# app/models/dummy.rb

class Dummy < ActiveRecord::Base
  # column name: :string
end
```

```ruby
# app/controllers/dummies_controller.rb

class DummiesController < ApplicationController
  include ProgrammableScaffoldRails::ActionControllerExtensions

  programmable_scaffold class_name: 'Dummy',
                        table_name: 'dummies'

  def model_params
    params.require(:dummy).permit(:name)
  end
end
```

### I18n

You can change these keys in your locales to have your application easily localized:

| Key | Value |
|-----|-------|
| `programmable_scaffold_rails.after_create_notice`  | %{model_class} was successfully created.   |
| `programmable_scaffold_rails.after_update_notice`  | %{model_class} was successfully updated.   |
| `programmable_scaffold_rails.after_destroy_notice` | %{model_class} was successfully destroyed. |
| `programmable_scaffold_rails.after_create_alert`   | %{model_class} cannot be created.          |
| `programmable_scaffold_rails.after_update_alert`   | %{model_class} cannot be updated.          |
| `programmable_scaffold_rails.after_destroy_alert`  | %{model_class} cannot be destroyed.        |

#### Regarding model_class

Model class is auto-calculated with  `model_instance.class.model_name.human`, if you localize your model
class following Rails standards, you shouldn't have any problem.

## Features

- `I18n` messages for successfully or failed action
- [friendly_id](https://github.com/norman/friendly_id) support

# TODO

- Improve readme by explaining what each "scaffold" action does
- Add I18n keys to completely replace those with `model_class`, if for example someone want to insert custom messages for each controller, something like `programmable_scaffold_rails.<controller_name>.after_create_notice`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
