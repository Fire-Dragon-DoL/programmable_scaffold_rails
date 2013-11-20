require 'spec_helper'
require 'internal/app/controllers/dummies_controller'


describe DummiesController do
  before do
    controller.stub(:render).with(any_args()).and_return(nil)
  end

  it "GET #new" do
    get :new

    assigns(:dummy).should_not be instance_of(Dummy)
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
end