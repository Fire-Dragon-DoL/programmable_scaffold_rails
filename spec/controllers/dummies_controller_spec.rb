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

  context "with json disabled" do
    before(:each) do
      controller.programmable_scaffold_controller_helpers
                .stub(:formats).and_return([:html])
    end

    it "POST #create" do
      dummy_params = FactoryGirl.attributes_for(:dummy)
      
      expect{post :create, dummy: dummy_params, format: :json}.to raise_error(ActionController::UnknownFormat)
    end

    it "PUT/PATCH #update" do
      dummy_name          = 'dummy2'
      dummy               = FactoryGirl.create(:dummy, name: 'dummy1')

      expect{put :update, id: dummy.id, dummy: { name: dummy_name }, format: :json}.to raise_error(ActionController::UnknownFormat)
    end

    it "DELETE #destroy" do
      dummy = FactoryGirl.create(:dummy)
      
      expect{delete :destroy, id: dummy.id, format: :json}.to raise_error(ActionController::UnknownFormat)
    end

  end

  context "with json enabled" do
    before(:each) do
      controller.programmable_scaffold_controller_helpers
                .stub(:formats).and_return([:html, :json])
    end

    it "POST #create" do
      dummy_params = FactoryGirl.attributes_for(:dummy)
      
      expect{post :create, dummy: dummy_params, format: :json}.not_to raise_error
    end

    it "PUT/PATCH #update" do
      dummy_name          = 'dummy2'
      dummy               = FactoryGirl.create(:dummy, name: 'dummy1')

      expect{put :update, id: dummy.id, dummy: { name: dummy_name }, format: :json}.not_to raise_error
    end

    it "DELETE #destroy" do
      dummy = FactoryGirl.create(:dummy)
      
      expect{delete :destroy, id: dummy.id, format: :json}.not_to raise_error
    end

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

  context "after_XXX_url" do
    let(:controller_helpers) { controller_helpers = controller.programmable_scaffold_controller_helpers }

    its "called during POST #create" do
      dummy_params = FactoryGirl.attributes_for(:dummy)

      controller_helpers.should_receive(:after_create_url)
                        .with(kind_of(ActiveRecord::Base))
                        .and_call_original
      post :create, dummy: dummy_params
    end

    its "called during PUT/PATCH #update" do
      dummy_name          = 'dummy2'
      dummy               = FactoryGirl.create(:dummy, name: 'dummy1')

      controller_helpers.should_receive(:after_update_url)
                        .with(kind_of(ActiveRecord::Base))
                        .and_call_original
      put :update, id: dummy.id, dummy: { name: dummy_name }
    end

    its "called during DELETE #destroy" do
      dummy = FactoryGirl.create(:dummy)

      controller_helpers.should_receive(:after_destroy_url)
                        .with(kind_of(ActiveRecord::Base))
                        .and_call_original
      
      delete :destroy, id: dummy.id
    end

    context "runs with namespace set" do
      let(:dummy) { FactoryGirl.create(:dummy) }

      it "after_create_url returns an url with namespace when is set" do
        controller_helpers.stub(:url_namespace).and_return('admin')

        controller_helpers.send(:after_create_url, dummy).should end_with "/admin/dummies/#{ dummy.id }"
      end

      it "after_create_url returns an url without namespace when is not set" do
        controller_helpers.send(:after_create_url, dummy).should end_with "/dummies/#{ dummy.id }"
      end

      it "after_update_url returns an url with namespace when is set" do
        controller_helpers.stub(:url_namespace).and_return('admin')

        controller_helpers.send(:after_update_url, dummy).should end_with "/admin/dummies/#{ dummy.id }"
      end

      it "after_update_url returns an url without namespace when is not set" do
        controller_helpers.send(:after_update_url, dummy).should end_with "/dummies/#{ dummy.id }"
      end

      it "after_destroy_url returns an url with namespace when is set" do
        controller_helpers.stub(:url_namespace).and_return('admin')

        controller_helpers.send(:after_destroy_url, dummy).should end_with "/admin/dummies"
      end

      it "after_destroy_url returns an url without namespace when is not set" do
        controller_helpers.send(:after_destroy_url, dummy).should end_with "/dummies"
      end

    end

    [:create, :update, :destroy].each do |crud_action|
      context "#{ crud_action }" do
        let(:dummy) { FactoryGirl.create(:dummy) }
        let(:old_options) { controller_helpers.send(:options).dup }

        its "called with a symbol and runs a method on the controller with after_#{ crud_action }_url name" do
          old_options[:"after_#{ crud_action }_url"] = :"dummy_after_#{ crud_action }_url"
          controller_helpers.stub(:options).and_return(old_options.freeze)
          controller.stub(:"dummy_after_#{ crud_action }_url").with(anything()).and_return(controller.dummies_url)

          controller_helpers.send(:"after_#{ crud_action }_url", dummy).should match controller.dummies_url
        end

        its "called with a proc and runs it" do
          # XXX: Notice that in this case self is == to controller because code is
          #      instance_exec-uted
          old_options[:"after_#{ crud_action }_url"] = ->(obj) { self.dummies_url }
          controller_helpers.stub(:options).and_return(old_options.freeze)

          controller_helpers.send(:"after_#{ crud_action }_url", dummy).should match controller.dummies_url
        end

      end
    end

    context "I18n flash message" do
      before(:each) do
        I18n.locale = :en
      end

      context "with valid data" do

        it "POST #create calls I18n", focus: true do
          dummy_params = FactoryGirl.attributes_for(:dummy)

          I18n.should_receive(:translate)
                        .with(any_arguments())
                        .and_call_original

          post :create, dummy: dummy_params
        end

        it "POST #create set correct flash notice" do
          dummy_params = FactoryGirl.attributes_for(:dummy)          
          post :create, dummy: dummy_params

          flash[:notice].should match 'was successfully created.'
        end

      end

    end


  end

end