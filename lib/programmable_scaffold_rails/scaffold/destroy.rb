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

        if instance.destroy
          respond_to do |format|
            format.html { redirect_to url_for(scaffold_helper.multiple_instances_name),
                                      notice: I18n.t('programmable_scaffold_rails.after_destroy_notice') }
            format.json { head :no_content }
          end
        else
          respond_to do |format|
            # XXX: Check if redirect_to :back doesn't create issues with failing
            #      destroy and redirect loops
            format.html { redirect_to :back,
                                      alert: I18n.t('programmable_scaffold_rails.after_destroy_alert') }
            format.json { render json: instance.errors, status: :unprocessable_entity }
          end
        end
      end
      
    end

  end

end