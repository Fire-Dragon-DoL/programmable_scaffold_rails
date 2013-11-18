module ProgrammableScaffoldRails

  # Used to avoid polluting controller class with methods
  class ControllerHelpers

    def initialize(parent)
      @parent = parent
    end

    def klass
      @klass ||= parent.controller_name
    end

  end

end