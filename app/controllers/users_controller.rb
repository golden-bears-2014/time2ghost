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

  # Are you adding blank whitespace for style points?


end
