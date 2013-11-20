require 'programmable_scaffold_rails/action_controller_helpers'

module ProgrammableScaffoldRails

  module Scaffold

    module New

      def new
        scaffold_helper = self.programmable_scaffold_controller_helpers
        self.instance_variable_set(scaffold_helper.single_instance,
                                   scaffold_helper.klass.new)
        instance = self.instance_variable_get(scaffold_helper.single_instance)
        authorize!(:create, instance) if scaffold_helper.cancan
      end
      
    end

  end

end