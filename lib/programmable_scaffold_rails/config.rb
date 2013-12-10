require 'yaml'
require 'active_support'
require 'active_support/core_ext'

module ProgrammableScaffoldRails
  CRUD_METHODS = [ :new,
                   :create,
                   :index,
                   :show,
                   :edit,
                   :update,
                   :destroy ].freeze

  BASE_OPTIONS = HashWithIndifferentAccess.new(YAML.load(File.read(File.expand_path('../../../config/action_controller.yml', __FILE__)))).freeze
end