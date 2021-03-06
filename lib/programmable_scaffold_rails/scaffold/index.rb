require 'programmable_scaffold_rails/action_controller_helpers'

module ProgrammableScaffoldRails

  module Scaffold

    module Index

      def index
        scaffold_helper = self.programmable_scaffold_controller_helpers
        self.instance_variable_set(scaffold_helper.multiple_instances,
                                   scaffold_helper.klass.all)
        authorize!(:read, scaffold_helper.klass) if scaffold_helper.cancan
      end
      
    end

  end

end