module ProgrammableScaffoldRails

  module Scaffold

    module Index

      def index
        self.instance_variable_set(self.programmable_scaffold_options.multiple_instances,
                                   self.programmable_scaffold_options.klass.all)
      end
      
    end

  end

end