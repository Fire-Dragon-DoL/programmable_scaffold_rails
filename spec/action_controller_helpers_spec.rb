require 'spec_helper'
require 'programmable_scaffold_rails/action_controller_helpers'

describe ProgrammableScaffoldRails::ActionControllerHelpers do
  class Stubbed
  end

  let(:controller_class_with_scaffold) do
    Class.new do
      include ::ProgrammableScaffoldRails::ActionControllerExtensions
      programmable_scaffold
    end
  end
  let(:controller) do
    obj = controller_class_with_scaffold.new
    obj.stub(:controller_name).and_return('stubbeds')

    obj
  end

  it { controller.should respond_to(:programmable_scaffold_controller_helpers) }

  subject(:controller_options) { controller.programmable_scaffold_controller_helpers }
    specify { controller_options.should respond_to(:klass)               }
    specify { controller_options.should respond_to(:table)               }
    specify { controller_options.should respond_to(:single_instance)     }
    specify { controller_options.should respond_to(:multiple_instances)  }
    specify { controller_options.should respond_to(:url_namespace)       }
    specify { controller_options.klass.should be Stubbed                 }
    specify { controller_options.table.should be :stubbeds               }
    specify { controller_options.single_instance.should be :@stubbed     }
    specify { controller_options.multiple_instances.should be :@stubbeds }
    specify { controller_options.url_namespace.should match ''           }

end