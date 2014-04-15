require 'spec_helper'

describe UsersController do
  let!(:test_user){FactoryGirl.create(:user)}

  context "#show" do
    it "renders show page" do
      get :show, test_user.attributes
      expect(response).to redirect_to(:profile)
    end
  end

  context "#new" do
    it "makes empty user for new user form" do
      get :new
      expect(assigns(:user).attributes).to eq(User.new.attributes)
    end
  end

  context "#create" do
    it "creates a new user" do
      expect {
        post :create, :user => FactoryGirl.attributes_for(:user)
      }.to change { User.count }.by(1)
    end

    it "redirects after creating new user" do
      post :create, :user => FactoryGirl.attributes_for(:user)
      expect(response).to redirect_to(:root)
    end
  end
end