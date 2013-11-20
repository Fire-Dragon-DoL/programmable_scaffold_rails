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

    it "calls after_create_url with createdobject and success result" do
      controller_helpers = controller.programmable_scaffold_controller_helpers
      dummy_params = FactoryGirl.attributes_for(:dummy)

      controller_helpers.should_receive(:after_update_url).with(instance_of(ActiveRecord::Base))
      post :create, dummy: dummy_params
    end

  end

end