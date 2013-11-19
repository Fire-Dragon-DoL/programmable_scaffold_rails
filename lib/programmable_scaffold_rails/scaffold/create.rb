module ProgrammableScaffoldRails

  module Scaffold

    module Create

      def create
        scaffold_helper = self.programmable_scaffold_controller_helpers
        self.instance_variable_set(scaffold_helper.single_instance,
                                   scaffold_helper.klass.new(
                                     scaffold_helper.call_strong_params
                                   ))
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
      
    end

  end

end