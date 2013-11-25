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
  let(:allowed_after_actions) { [nil, :edit, :show] }

  it { controller.should respond_to(:programmable_scaffold_controller_helpers) }

  subject(:controller_helpers) { controller.programmable_scaffold_controller_helpers }
    specify { controller_helpers.should respond_to(:klass)                   }
    specify { controller_helpers.should respond_to(:table)                   }
    specify { controller_helpers.should respond_to(:single_instance_name)    }
    specify { controller_helpers.should respond_to(:single_instance)         }
    specify { controller_helpers.should respond_to(:multiple_instances_name) }
    specify { controller_helpers.should respond_to(:multiple_instances)      }
    specify { controller_helpers.should respond_to(:url_namespace)           }
    specify { controller_helpers.should respond_to(:friendly_id)             }
    specify { controller_helpers.should respond_to(:strong_params)           }
    specify { controller_helpers.should respond_to(:call_strong_params)      }
    specify { controller_helpers.should respond_to(:cancan)                  }
    specify { controller_helpers.should respond_to(:after_create_action)     }
    specify { controller_helpers.should respond_to(:after_update_action)     }
    specify { controller_helpers.should respond_to(:after_update_url)        }
    specify { controller_helpers.should respond_to(:after_create_url)        }
    specify { controller_helpers.should respond_to(:after_destroy_url)       }
    specify { controller_helpers.should respond_to(:formats)                 }
    specify { controller_helpers.klass.should be Stubbed                     }
    specify { controller_helpers.table.should be :stubbeds                   }
    specify { controller_helpers.single_instance_name.should be :stubbed     }
    specify { controller_helpers.single_instance.should be :@stubbed         }
    specify { controller_helpers.multiple_instances_name.should be :stubbeds }
    specify { controller_helpers.multiple_instances.should be :@stubbeds     }
    specify { controller_helpers.url_namespace.should match ''               }
    specify { controller_helpers.friendly_id.should be_false                 }
    specify { controller_helpers.strong_params.should be :model_params       }
    specify { controller_helpers.cancan.should be_true                       }
    specify { allowed_after_actions.should include(controller_helpers.after_create_action) }
    specify { allowed_after_actions.should include(controller_helpers.after_update_action) }
    specify { controller_helpers.formats.should match_array([:html, :json]) }

  it "is valid to use nil as after_create_action" do
    controller_helpers.stub(:after_create_action).and_return(nil)
    allowed_after_actions.should include(controller_helpers.after_create_action)
  end

  it "is valid to use nil as after_update_action" do
    controller_helpers.stub(:after_update_action).and_return(nil)
    allowed_after_actions.should include(controller_helpers.after_update_action)
  end

  it "has not implemented strong_params method that will be called" do
    expect do
      controller_helpers.call_strong_params
    end.to raise_error(NotImplementedError)
  end

  context "when searching in database" do
    subject(:dummy_model) { Stubbed.new }

    it "can search item without slug" do
      controller_helpers.stub_chain('klass.find').and_return(dummy_model)

      controller_helpers.find_by_id_or_friendly_id({ id: 1 }).should be dummy_model
    end

    it "can search item with slug" do
      controller_helpers.stub(:friendly_id).and_return(true)
      controller_helpers.stub_chain('klass.friendly.find').and_return(dummy_model)

      controller_helpers.find_by_id_or_friendly_id({ id: 'dummy' }).should be dummy_model
    end    
  end

end