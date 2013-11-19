require 'spec_helper'
require 'internal/app/controllers/dummies_controller'


describe DummiesController do
  before do
    controller.stub(:render).with(any_args()).and_return(nil)
  end

  it "GET #index" do
    dummies = FactoryGirl.create_list(:dummy, 2)

    get :index

    assigns(:dummies).should match_array(dummies)
  end

        # @user = User.new(user_params)

        # respond_to do |format|
        #   if @user.save
        #     format.html { redirect_to @user, notice: 'User was successfully created.' }
        #     format.json { render action: 'show', status: :created, location: @user }
        #   else
        #     format.html { render action: 'new' }
        #     format.json { render json: @user.errors, status: :unprocessable_entity }
        #   end
        # end
end