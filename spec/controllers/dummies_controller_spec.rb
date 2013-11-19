require 'spec_helper'
require 'internal/app/controllers/dummies_controller'


describe DummiesController do

  it "GET #index" do
    get :index
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