class UsersController < ApplicationController
  include SessionHelper

  def show
    @user = current_user
    redirect_to root_path
  end

  def profile
    @user = current_user
    render :show
  end

  def new
    @user = User.new
  end

  def create
    # Many consider it a code smell to modify passed-in parameters.
    # Rather than just update the params give the result a name
    #
    #
    # cleaned_phone_number = params[:user][:phone_number].gsub(/[^0-9]/, "")
    #
    # Over and above that, could you pattern match this and store it as a
    # string.
    #
    # Also, maybe this could be done as an extracted method
    #
    # which has the implementation of:
    #
    # "444-233-8888".scan(/\d{3}-\d{3}-\d{4}/).shift

    params[:user][:phone_number].gsub!(/[^0-9]/, "")
    @user = User.new params[:user]
    if @user.save
      session[:user_id] = @user.id
      flash[:create] = "Account Created Successfully"
      redirect_to root_path
    else
      flash[:error] = "Account not created. Please try again."
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    if @user.save
      redirect_to user_path, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

end
