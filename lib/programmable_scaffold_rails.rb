require 'programmable_scaffold_rails/version'
require 'programmable_scaffold_rails/config'
require 'programmable_scaffold_rails/action_controller_extensions'

module ProgrammableScaffoldRails #:nodoc
end

# load Rails/Railtie
begin
  require 'rails'
rescue LoadError
  #do nothing
end

if defined? Rails
  require 'programmable_scaffold_rails/engine'
end