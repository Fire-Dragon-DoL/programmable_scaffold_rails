require 'programmable_scaffold_rails/action_controller_helpers'

module ProgrammableScaffoldRails

  module Scaffold

    module New

      def new
        scaffold_helper = self.programmable_scaffold_controller_helpers
        self.instance_variable_set(scaffold_helper.single_instance,
                                   scaffold_helper.klass.new)
      end
      
    end

  end

end