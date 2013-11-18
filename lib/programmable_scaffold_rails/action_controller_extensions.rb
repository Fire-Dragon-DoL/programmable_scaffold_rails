require 'active_support'
require 'active_support/core_ext'

require 'programmable_scaffold_rails/config'
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

    module ClassMethods

      def programmable_scaffold(options={})
        options = ::ProgrammableScaffoldRails::BASE_OPTIONS.merge(options)
        crud    = ::ProgrammableScaffoldRails::CRUD_METHODS

        # Validate
        if options.include?(:only) && options.include?(:except)
          raise ":only and :except option must not be used toghether"
        end

        crud = options[:only]          if options.include?(:only)
        crud = crud - options[:except] if options.include?(:except)

        # Process

        send(:include, ProgrammableScaffoldRails::Scaffold::New)     if crud.include?(:new)
        send(:include, ProgrammableScaffoldRails::Scaffold::Create)  if crud.include?(:create)
        send(:include, ProgrammableScaffoldRails::Scaffold::Index)   if crud.include?(:index)
        send(:include, ProgrammableScaffoldRails::Scaffold::Show)    if crud.include?(:show)
        send(:include, ProgrammableScaffoldRails::Scaffold::Edit)    if crud.include?(:edit)
        send(:include, ProgrammableScaffoldRails::Scaffold::Update)  if crud.include?(:update)
        send(:include, ProgrammableScaffoldRails::Scaffold::Destroy) if crud.include?(:destroy)

        # Store
        const_set(:PROGRAMMABLE_SCAFFOLD, options.freeze)
      end

    end
    # attr_reader :programmable_scaffold

    # class << self
    #   def programmable_scaffold(options={})
    #     options = ProgrammableScaffoldRails::BASE_OPTIONS.merge(options)

    #     validate_programmable_scaffold!(options)

    #     # Do something with options
    #     options[:klass] = options[:class].to_s.classify.constantize
    #     options[:table] = options[:table].try(:to_sym) || options[:table].to_s.tableize.to_sym
    #     options[:single_instance_variable]    = options[:single_instance_variable].try(:to_sym) ||
    #                                             options[:table].to_s.singularize.to_sym
    #     options[:multiple_instances_variable] = options[:multiple_instances_variable].try(:to_sym) ||
    #                                             options[:table].to_s.pluralize.to_sym
    #     #       # Generate missing options
    #     # klass     = ce_options[:model].to_s.classify.constantize
    #     # table     = ce_options[:model].to_s.tableize.to_sym
    #     # instance  = ce_options[:model].to_s.tableize.singularize.to_sym
    #     # instances = ce_options[:model].to_s.tableize.pluralize.to_sym
    #     # admin     = true
    #     # admin     = !!ce_options[:admin] if ce_options.include?(:admin)
    #     # admin_str = 'admin_' if admin

    #     # instance_text = I18n.t("activerecord.models.#{ instance }")

    #     set_programmable_scaffold!(options)
    #   end

    #   def validate_programmable_scaffold!(options)
    #     unless options.include?(:class) &&
    #           !options[:class].nil?
    #       raise 'Model key required'
    #     end
    #   end

    #   def set_programmable_scaffold!(options)
    #     const_set(:PROGRAMMABLE_SCAFFOLD, options.freeze)
    #   end
    # end

    # def programmable_scaffold
    #   self.class::PROGRAMMABLE_SCAFFOLD
    # end

    #       # model_class:               klass,
    #       # model_table:               table,
    #       # model_instance:            instance,
    #       # model_instances:           instances,
    #       # model_paging:              false,
    #       # formats:                   [:html],
    #       # cancan:                    true,
    #       # select2_query:             false,
    #       # after_update_url:          :"edit_#{ admin_str }#{ instance }_url",
    #       # after_update_notice:       "#{ instance_text } è stato aggiornato",
    #       # after_update_with_value:   true,
    #       # after_create_url:          :"edit_#{ admin_str }#{ instance }_url",
    #       # after_create_notice:       "#{ instance_text } è stato creato",
    #       # after_create_with_value:   true,
    #       # after_destroy_url:         :"#{ admin_str }#{ instances }_url",
    #       # after_destroy_notice:      "#{ instance_text } è stato cancellato",
    #       # after_destroy_with_value:  false,
    #       # after_destroy_fail_url:    :"#{ admin_str }#{ instances }_url",
    #       # after_destroy_fail_notice: "Non è stato possibile cancellare #{ instance_text }"

  end

end