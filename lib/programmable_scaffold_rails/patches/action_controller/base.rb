require 'programmable_scaffold_rails/action_controller_extensions'

ActionController::Base.class_eval do
  include ::ProgrammableScaffoldRails::ActionControllerExtensions
end