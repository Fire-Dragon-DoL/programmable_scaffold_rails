require 'spec_helper'
require 'programmable_scaffold_rails/action_controller_extensions'

describe ProgrammableScaffoldRails::ActionControllerExtensions do
  let(:stubbeds_controller_class) do
    Class.new do
      include ::ProgrammableScaffoldRails::ActionControllerExtensions
    end
  end
  let(:stubbeds_controller_class_with_scaffold) do
    Class.new do
      include ::ProgrammableScaffoldRails::ActionControllerExtensions
      
      programmable_scaffold
    end
  end

  it { stubbeds_controller_class.should respond_to(:programmable_scaffold) }

  it "does not allow to use :extend and :only at same time in programmable_scaffold" do
    expect do
      Class.new do
        include ::ProgrammableScaffoldRails::ActionControllerExtensions
        
        programmable_scaffold only: [], except: []
      end
    end.to raise_error
  end

  it "does not have included Scaffold::New module because of the :only option" do
    # XXX: Be careful, testing against #new method can be tricky because it
    #      it exists on all objects
    Class.new do
      include ::ProgrammableScaffoldRails::ActionControllerExtensions
      
      programmable_scaffold only: [:create]
    end.included_modules.should_not include(::ProgrammableScaffoldRails::Scaffold::New)
  end

  it "does not have included Scaffold::Create module because of the :except option" do
    Class.new do
      include ::ProgrammableScaffoldRails::ActionControllerExtensions
      
      programmable_scaffold except: [:new]
    end.included_modules.should_not include(::ProgrammableScaffoldRails::Scaffold::New)
  end

  context "with scaffold methods" do
    subject(:controller) do
      obj = stubbeds_controller_class_with_scaffold.new
      obj.stub(:controller_name) { 'stubbeds' }
      obj
    end
      specify { controller.should respond_to(:new) }
      specify { controller.should respond_to(:create) }
      specify { controller.should respond_to(:index) }
      specify { controller.should respond_to(:show) }
      specify { controller.should respond_to(:edit) }
      specify { controller.should respond_to(:update) }
      specify { controller.should respond_to(:destroy) }

  end

end