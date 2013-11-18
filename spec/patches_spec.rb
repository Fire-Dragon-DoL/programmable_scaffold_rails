require 'spec_helper'

module ActionController
  class Base
  end
end

require 'programmable_scaffold_rails/patches/action_controller/base'

describe "Patches" do

  it { ActionController::Base.should respond_to(:programmable_scaffold) }

end