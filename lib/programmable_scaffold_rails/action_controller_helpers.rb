require 'active_support'
require 'active_support/core_ext'

module ProgrammableScaffoldRails

  # Used to avoid polluting controller class with methods
  class ActionControllerHelpers

    def initialize(parent)
      @parent = parent
    end

    def klass
      return @klass if @klass

      @klass = options[:class_name].try(:to_s) || controller.controller_name.to_s
      @klass = @klass.classify.constantize
    end

    def table
      return @table if @table

      @table = options[:table_name].try(:to_s) || klass.to_s
      @table = @table.tableize.to_sym
    end

    def cancan
      return @cancan unless @cancan.nil?

      @cancan = !!options[:cancan]
    end

    def single_instance_name
      return @single_instance_name if @single_instance_name

      @single_instance_name = options[:single_instance_name].try(:to_s) || table.to_s
      @single_instance_name = @single_instance_name.singularize.to_sym
    end

    def single_instance
      @single_instance ||= "@#{ single_instance_name }".to_sym
    end

    def multiple_instances_name
      return @multiple_instances_name if @multiple_instances_name

      @multiple_instances_name = options[:multiple_instances_name].try(:to_s) || table.to_s
      @multiple_instances_name = @multiple_instances_name.pluralize.to_sym
    end

    def multiple_instances
      @multiple_instances ||= "@#{ multiple_instances_name }".to_sym
    end

    def url_namespace
      return @url_namespace if @url_namespace

      @url_namespace = options[:url_namespace].try(:to_s) || ''
    end

    def after_create_action
      @after_create_action = options[:after_create_action].try(:to_sym)
    end

    def after_update_action
      @after_update_action = options[:after_update_action].try(:to_sym)
    end

    def friendly_id
      return @friendly_id unless @friendly_id.nil?

      @friendly_id = !!options[:friendly_id]
    end

    def find_by_id_or_friendly_id(params)
      found = nil
      if friendly_id && klass.respond_to?(:friendly)
        found = klass.friendly.find(params[:id])
      else
        found = klass.find(params[:id])
      end

      found
    end

    def strong_params
      @strong_params ||= options[:strong_params].try(:to_sym)
    end

    def call_strong_params
      unless controller.respond_to?(strong_params)
        raise NotImplementedError, 'No strong_params method specified'
      end
      controller.send(strong_params)
    end

    def after_create_url(obj)
      run_after_url_call_or_yield(:create, obj) { after_create_or_update_default_url(:create, obj) }
    end

    def after_update_url(obj)
      run_after_url_call_or_yield(:update, obj) { after_create_or_update_default_url(:create, obj) }
    end

    def after_destroy_url(obj)
      run_after_url_call_or_yield(:destroy, obj) do
        if url_namespace.blank?
          controller.url_for(multiple_instances_name)
        else
          controller.url_for([url_namespace, multiple_instances_name])
        end
      end
    end

    protected

      def after_create_or_update_default_url(crud_action, obj)
        after_action = send(:"after_#{ crud_action }_action")
        if url_namespace.blank?
          if after_action.nil? || after_action == :show
            controller.url_for(obj)
          else # :edit
            controller.url_for([:edit, obj])
          end
        else
          if after_action.nil? || after_action == :show
            controller.url_for([url_namespace, obj])
          else # :edit
            controller.url_for([:edit, url_namespace, obj])
          end
        end
      end

      def controller
        @parent
      end

    private

      def options
        @parent.class.programmable_scaffold_options
      end

      def run_after_url_call_or_yield(crud_action, obj)
        after_url = options[:"after_#{ crud_action }_url"]
        if after_url.class <= Symbol
          controller.send(after_url, obj)
        elsif after_url.class <= Proc
          controller.instance_exec(obj, &after_url)
        else
          yield
        end
      end

  end

end