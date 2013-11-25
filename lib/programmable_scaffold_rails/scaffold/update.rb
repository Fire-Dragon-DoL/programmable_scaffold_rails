require 'programmable_scaffold_rails/action_controller_helpers'

module ProgrammableScaffoldRails

  module Scaffold

    module Update

      def update
        scaffold_helper = self.programmable_scaffold_controller_helpers
        self.instance_variable_set(scaffold_helper.single_instance,
                                   scaffold_helper.find_by_id_or_friendly_id(params))
        instance = self.instance_variable_get(scaffold_helper.single_instance)
        authorize!(:update, instance) if scaffold_helper.cancan
        
        respond_to do |format|
          if instance.update(scaffold_helper.call_strong_params)
            format.html { redirect_to scaffold_helper.after_update_url(instance), notice: I18n.t('programmable_scaffold_rails.after_update_notice') }
            format.json { head :no_content }
          else
            format.html do
              flash.alert = I18n.t('programmable_scaffold_rails.after_update_alert')
              render action: 'edit'
            end
            format.json { render json: instance.errors, status: :unprocessable_entity }
          end
        end
      end
      
    end

  end

end