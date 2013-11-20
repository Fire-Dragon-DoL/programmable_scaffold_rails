require 'programmable_scaffold_rails/action_controller_helpers'

module ProgrammableScaffoldRails

  module Scaffold

    module Destroy

      def destroy
        scaffold_helper = self.programmable_scaffold_controller_helpers
        self.instance_variable_set(scaffold_helper.single_instance,
                                   scaffold_helper.find_by_id_or_friendly_id(params))
        instance = self.instance_variable_get(scaffold_helper.single_instance)
        authorize!(:destroy, instance) if scaffold_helper.cancan

        instance.destroy
        
        respond_to do |format|
          format.html { redirect_to url_for(:dummies) }
          format.json { head :no_content }
        end
      end
      
    end

  end

end