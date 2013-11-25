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
        authorize!(:create, instance) if scaffold_helper.cancan

        respond_to do |format|
          if instance.save
            scaffold_helper.formats.each do |used_format|
              case used_format
              when :html
                format.html { redirect_to scaffold_helper.after_create_url(instance),
                                          notice: I18n.t('programmable_scaffold_rails.after_create_notice',
                                                         model_class: instance.class.model_name.human) }
              when :json
                format.json { render action: 'show', status: :created, location: instance }
              end
            end
          else
            scaffold_helper.formats.each do |used_format|
              case used_format
              when :html
                format.html do
                  flash[:alert] = I18n.t('programmable_scaffold_rails.after_create_alert',
                                         model_class: instance.class.model_name.human)
                  render action: 'new'
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