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

      @klass = options[:class_name].try(:to_s) || @parent.controller_name.to_s
      @klass = @klass.classify.constantize
    end

    def table
      return @table if @table

      @table = options[:table_name].try(:to_s) || klass.to_s
      @table = @table.tableize.to_sym
    end

    def single_instance_name
      return @single_instance_name if @single_instance_name

      @single_instance_name = options[:single_instance_name].try(:to_s) || table.to_s
      @single_instance_name = @single_instance_name.singularize.to_sym
    end

    def single_instance
      return @single_instance if @single_instance

      @single_instance = options[:single_instance_name].try(:to_s) || table.to_s
      @single_instance = "@#{ @single_instance.singularize }".to_sym
    end

    def multiple_instances_name
      return @multiple_instances_name if @multiple_instances_name

      @multiple_instances_name = options[:multiple_instances_name].try(:to_s) || table.to_s
      @multiple_instances_name = @multiple_instances_name.pluralize.to_sym
    end

    def multiple_instances
      return @multiple_instances if @multiple_instances

      @multiple_instances = options[:multiple_instances_name].try(:to_s) || table.to_s
      @multiple_instances = "@#{ @multiple_instances.pluralize }".to_sym
    end

    def url_namespace
      return @url_namespace if @url_namespace

      @url_namespace = options[:url_namespace].try(:to_s) || ''
    end

    def friendly_id
      return @friendly_id if @friendly_id

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
      return @strong_params if @strong_params

      @strong_params = options[:strong_params].try(:to_sym)
    end

    def call_strong_params
      unless @parent.respond_to?(strong_params)
        raise NotImplementedError, 'No strong_params method specified'
      end
      @parent.send(strong_params)
    end

    private

      def options
        @parent.class.programmable_scaffold_options
      end

  end

end