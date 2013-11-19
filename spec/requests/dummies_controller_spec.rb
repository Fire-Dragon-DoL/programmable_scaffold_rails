require 'spec_helper'
require 'internal/app/controllers/dummies_controller'

describe DummiesController do
  let(:controller_format) do
    double('Controller format object', html: nil, json: nil)
  end

  subject(:controller) do
    obj = described_class.new
    obj.stub(:respond_to) do
      yield(controller_format)
    end
    obj.stub(:redirect_to).with(anything()).and_return(nil)
    obj.stub(:render).with(anything()).and_return(nil)
    obj.stub_chain('params.require.permit').with()
                                           .with(:symbol)
                                           .with(anything())
                                           .and_return({ name: 'mydummy' })
    obj
  end
    specify { described_class.should respond_to(:programmable_scaffold_options) }

  it "creates a new instance of Dummy" do
    controller.create
    controller.instance_variable_get(:@dummy).should_not be_nil
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