module ProgrammableScaffoldRails

  module Scaffold

    module Update

      def update
        scaffold_helper = self.programmable_scaffold_controller_helpers
        self.instance_variable_set(scaffold_helper.single_instance,
                                   scaffold_helper.find_by_id_or_friendly_id(params))
      end
      
    end

  end

end