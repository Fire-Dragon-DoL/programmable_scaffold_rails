require 'programmable_scaffold_rails/action_controller_helpers'

module ProgrammableScaffoldRails

  module Scaffold

    module Create

      def create
        scaffold_helper = self.programmable_scaffold_controller_helpers
        self.instance_variable_set(scaffold_helper.single_instance,
                                   scaffold_helper.klass.new(
                                     scaffold_helper.call_strong_params
                                   ))
        instance = self.instance_variable_get(scaffold_helper.single_instance)

        respond_to do |format|
          if instance.save
            format.html { redirect_to instance, notice: 'User was successfully created.' }
            format.json { render action: 'show', status: :created, location: instance }
          else
            format.html { render action: 'new' }
            format.json { render json: instance.errors, status: :unprocessable_entity }
          end
        end
      end
      
    end

  end

end