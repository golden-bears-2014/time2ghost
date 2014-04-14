class UsersController < ApplicationController
  include SessionHelper

  def show
    @user = correct_user
    redirect_to '/profile'
  end

  def profile
    @user = correct_user
    render :show
  end

  def new
    @user = User.new
  end

  def create
    params[:user][:phone_number].gsub!(/[^0-9]/, "")
    user = User.create params[:user]
    if user.valid?
      session[:user_id] = user.id
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
    # @user.username = params[:user][:username]
    # @user.password = params[:user][:password]
    # @user.email = params[:user][:email]
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
