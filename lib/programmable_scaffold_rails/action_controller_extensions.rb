require 'ostruct'
require 'active_support'
require 'active_support/core_ext'

require 'programmable_scaffold_rails/config'
require 'programmable_scaffold_rails/action_controller_helpers'
require 'programmable_scaffold_rails/scaffold/new'
require 'programmable_scaffold_rails/scaffold/create'
require 'programmable_scaffold_rails/scaffold/index'
require 'programmable_scaffold_rails/scaffold/show'
require 'programmable_scaffold_rails/scaffold/edit'
require 'programmable_scaffold_rails/scaffold/update'
require 'programmable_scaffold_rails/scaffold/destroy'

module ProgrammableScaffoldRails

  module ActionControllerExtensions

    extend ActiveSupport::Concern

    module InstanceHelpers

      def programmable_scaffold_controller_helpers
        @programmable_scaffold_controller_helpers ||= ::ProgrammableScaffoldRails::ActionControllerHelpers.new(self)
      end

    end

    module ClassMethods

      # This is the core method which generate the scaffold things.
      # It's important to notice that it uses a constant because it behaves like
      # a class, can be inherited, overridden in child classes but it's "frozen"
      # for the class where it's defined.
      def programmable_scaffold(options={})
        options = ::ProgrammableScaffoldRails::BASE_OPTIONS.merge(options)
        crud    = ::ProgrammableScaffoldRails::CRUD_METHODS

        # Validate
        if options.include?(:only) && options.include?(:except)
          raise ":only and :except option must not be used toghether"
        end

        # Process
        crud = options[:only]          if options.include?(:only)
        crud = crud - options[:except] if options.include?(:except)

        send( :include, ProgrammableScaffoldRails::ActionControllerExtensions::InstanceHelpers )

        send( :include, ProgrammableScaffoldRails::Scaffold::New     ) if crud.include?(:new)
        send( :include, ProgrammableScaffoldRails::Scaffold::Create  ) if crud.include?(:create)
        send( :include, ProgrammableScaffoldRails::Scaffold::Index   ) if crud.include?(:index)
        send( :include, ProgrammableScaffoldRails::Scaffold::Show    ) if crud.include?(:show)
        send( :include, ProgrammableScaffoldRails::Scaffold::Edit    ) if crud.include?(:edit)
        send( :include, ProgrammableScaffoldRails::Scaffold::Update  ) if crud.include?(:update)
        send( :include, ProgrammableScaffoldRails::Scaffold::Destroy ) if crud.include?(:destroy)

        # Store
        const_set(:PROGRAMMABLE_SCAFFOLD, OpenStruct.new(options).freeze)

        self
      end

      def programmable_scaffold_options
        const_get(:PROGRAMMABLE_SCAFFOLD)
      end

    end

  end

end