require 'spec_helper'
require 'internal/app/controllers/dummies_controller'


describe DummiesController do
  before(:each) do
    controller.stub(:authorize!).with(anything(), anything()).and_return(true)
  end

  it "GET #new" do
    get :new

    assigns(:dummy).should be_an_instance_of(Dummy)
  end

  it "POST #create" do
    dummy_params = FactoryGirl.attributes_for(:dummy)
    
    expect{post :create, dummy: dummy_params}.to change(Dummy, :count).by(1)
  end

  it "GET #index" do
    dummies = FactoryGirl.create_list(:dummy, 2)

    get :index

    assigns(:dummies).should match_array(dummies)
  end

  it "GET #show" do
    dummy = FactoryGirl.create(:dummy)

    get :show, id: dummy.id

    assigns(:dummy).should == dummy
  end

  it "GET #edit" do
    dummy = FactoryGirl.create(:dummy)

    get :edit, id: dummy.id

    assigns(:dummy).should == dummy
  end

  it "PUT/PATCH #update" do
    dummy_name          = 'dummy2'
    dummy               = FactoryGirl.create(:dummy, name: 'dummy1')

    put :update, id: dummy.id, dummy: { name: dummy_name }

    assigns(:dummy).name.should match dummy_name
  end

  it "DELETE #destroy" do
    dummy = FactoryGirl.create(:dummy)
    
    delete :destroy, id: dummy.id

    expect{dummy.class.find(dummy.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  context "without authorization" do
    before(:each) do
      controller.stub(:authorize!).with(anything(), anything()).and_raise
    end

    it "GET #new" do
      expect{get :new}.to raise_error
    end

    it "POST #create" do
      dummy_params = FactoryGirl.attributes_for(:dummy)
      expect{post :create, dummy: dummy_params}.to raise_error
    end

    it "GET #index" do
      dummies = FactoryGirl.create_list(:dummy, 2)

      expect{get :index}.to raise_error
    end

    it "GET #show" do
      dummy = FactoryGirl.create(:dummy)

      expect{get :show, id: dummy.id}.to raise_error
    end

    it "GET #edit" do
      dummy = FactoryGirl.create(:dummy)

      expect{get :edit, id: dummy.id}.to raise_error
    end

    it "PUT/PATCH #update" do
      dummy_name          = 'dummy2'
      dummy               = FactoryGirl.create(:dummy, name: 'dummy1')

      expect{put :update, id: dummy.id, dummy: { name: dummy_name }}.to raise_error
    end

    it "DELETE #destroy" do
      dummy = FactoryGirl.create(:dummy)
      
      expect{delete :destroy, id: dummy.id}.to raise_error
    end

  end

  context "with errors" do

    it "POST #create" do
      dummy_params = FactoryGirl.attributes_for(:dummy_invalid)

      post :create, dummy: dummy_params

      response.should render_template('new')
    end

    it "PUT/PATCH #update" do
      dummy_name          = 'dummy2'
      dummy               = FactoryGirl.create(:dummy, name: 'dummy1')

      put :update, id: dummy.id, dummy: { name: dummy_name, will_invalidate: true }

      response.should render_template('edit')
    end

  end

  context "POST #create" do
    let(:controller_helpers) { controller_helpers = controller.programmable_scaffold_controller_helpers }

    it "calls after_create_url with created object" do
      dummy_params = FactoryGirl.attributes_for(:dummy)

      controller_helpers.should_receive(:after_create_url)
                        .with(kind_of(ActiveRecord::Base))
                        .and_call_original
      post :create, dummy: dummy_params
    end

  end

  context "after_XXX_url" do
    [:create, :update, :destroy].each do |crud_action|
      let(:controller_helpers) { controller_helpers = controller.programmable_scaffold_controller_helpers }
      let(:dummy) { FactoryGirl.create(:dummy) }

      it "returns an url with namespace when is set" do
        controller_helpers.stub(:url_namespace).and_return('admin')

        controller_helpers.send(:"after_#{ crud_action }_url", dummy).should match "/admin/dummies/#{ dummy.id }"
      end

      it "returns an url without namespace when is not set" do
        controller_helpers.send(:"after_#{ crud_action }_url", dummy).should match "/dummies/#{ dummy.id }"
      end

      its "called with a symbol and runs a method on the controller with after_#{ crud_action }_url name" do
        old_options                                = controller_helpers.send(:options).dup
        old_options[:"after_#{ crud_action }_url"] = :"dummy_after_#{ crud_action }_url"
        controller_helpers.stub(:options).and_return(old_options.freeze)
        controller.stub(:"dummy_after_#{ crud_action }_url").with(anything()).and_return(controller.dummies_url)

        controller_helpers.send(:"after_#{ crud_action }_url", dummy).should match controller.dummies_url
      end

      its "called with a proc and runs it" do
        old_options                    = controller_helpers.send(:options).dup
        # XXX: Notice that in this case self is == to controller because code is
        #      instance_exec-uted
        old_options[:"after_#{ crud_action }_url"] = ->(obj) { self.dummies_url }
        controller_helpers.stub(:options).and_return(old_options.freeze)

        controller_helpers.send(:"after_#{ crud_action }_url", dummy).should match controller.dummies_url
      end
    end

  end

end