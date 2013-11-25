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
            scaffold_helper.formats.each do |used_format|
              case used_format
              when :html
                format.html { redirect_to scaffold_helper.after_destroy_url(instance),
                                          notice: I18n.t('programmable_scaffold_rails.after_destroy_notice',
                                                         model_class: instance.class.model_name.human) }
              when :json
                format.json { head :no_content }
              end
            end
          end
        else
          respond_to do |format|
            scaffold_helper.formats.each do |used_format|
              case used_format
              when :html
                # XXX: Check if redirect_to :back doesn't create issues with failing
                #      destroy and redirect loops
                format.html do
                  flash[:alert] = I18n.t('programmable_scaffold_rails.after_destroy_alert',
                                         model_class: instance.class.model_name.human)
                  redirect_to :back
                end
              when :json
                format.json { render json: instance.errors, status: :unprocessable_entity }
              end
            end
          end
        end
      end
      
    end

  end

end