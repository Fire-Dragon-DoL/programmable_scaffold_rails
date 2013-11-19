require 'spec_helper'
require 'programmable_scaffold_rails/action_controller_helpers'
require 'internal/app/models/dummy'

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

  subject(:controller_helpers) { controller.programmable_scaffold_controller_helpers }
    specify { controller_helpers.should respond_to(:klass)               }
    specify { controller_helpers.should respond_to(:table)               }
    specify { controller_helpers.should respond_to(:single_instance)     }
    specify { controller_helpers.should respond_to(:multiple_instances)  }
    specify { controller_helpers.should respond_to(:url_namespace)       }
    specify { controller_helpers.should respond_to(:friendly_id)         }
    specify { controller_helpers.klass.should be Stubbed                 }
    specify { controller_helpers.table.should be :stubbeds               }
    specify { controller_helpers.single_instance.should be :@stubbed     }
    specify { controller_helpers.multiple_instances.should be :@stubbeds }
    specify { controller_helpers.url_namespace.should match ''           }
    specify { controller_helpers.friendly_id.should be_false             }

  it "can search item without slug" do
    dummy_model = Dummy.new
    controller_helpers.stub(:klass).and_return(Dummy)
    Dummy.stub(:find).and_return(dummy_model)
    controller_helpers.find_by_id_or_friendly_id({ id: 1 }).should be dummy_model
  end

  it "can search item with slug" do
    dummy_model = Dummy.new
    controller_helpers.stub(:friendly_id).and_return(true)
    controller_helpers.stub(:klass).and_return(Dummy)
    Dummy.stub_chain('friendly.find').and_return(nil)
    controller_helpers.find_by_id_or_friendly_id({ id: 'dummy' }).should be dummy_model
  end

end