module ProgrammableScaffoldRails

  module Scaffold

    module Show

      def show
        self.instance_variable_set(self.programmable_scaffold_options.single_instance,
                                   self.programmable_scaffold_options.find_by_id_or_friendly_id(params))
      end
      
    end

  end

end