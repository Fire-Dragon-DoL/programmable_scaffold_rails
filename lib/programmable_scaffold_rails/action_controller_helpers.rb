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

    private

      def options
        @parent.class.programmable_scaffold_options
      end

  end

end