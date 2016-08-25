class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.find(params[:id])
  
    if params[:metonic] == "1"
      @metonic = true
    else
      @metonic = false
    end
    
    if @user != current_user
      flash[:alert] = "Not Allowed"
      redirect_to root_path
    end
  end
end
