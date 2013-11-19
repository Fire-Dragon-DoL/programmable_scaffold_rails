class DummiesController < ActionController::Base
  include ::ProgrammableScaffoldRails::ActionControllerExtensions

  programmable_scaffold

  def model_params
    params.require(:dummy).permit(:name)
  end
end