require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {
    { username: "testuser", email: "testuser@example.com", password: "password" }
  }

  let(:invalid_attributes) {
    { username: nil, email: "invalidemail", password: "short" }
  }

  let(:user) { User.create!(valid_attributes) }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: user.to_param }
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #edit" do
  before do
    @user = User.create!(valid_attributes)
    allow_any_instance_of(UsersController).to receive(:current_user).and_return(@user)
  end

  it "returns a success response" do
    get :edit, params: { id: @user.to_param }
    expect(response).to be_successful
    expect(response).to have_http_status(:ok)
  end
end


  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "redirects to the users index" do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(articles_path)
      end
    end

    context "with invalid params" do
      it "does not create a new User" do
        expect {
          post :create, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)
      end

      it "renders the new template" do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH/PUT #update" do
  before do
    @user = User.create!(valid_attributes)
    allow_any_instance_of(UsersController).to receive(:current_user).and_return(@user)
  end

  context "with valid params" do
    let(:new_attributes) {
      { username: "updateduser", email: "updateduser@example.com", password: "newpassword" }
    }

    it "updates the requested user" do
      patch :update, params: { id: @user.to_param, user: new_attributes }
      @user.reload
      expect(@user.username).to eq("updateduser")
      expect(@user.email).to eq("updateduser@example.com")
    end

    it "redirects to the user" do
      patch :update, params: { id: @user.to_param, user: new_attributes }
      expect(response).to redirect_to(@user)
    end
  end

  context "with invalid params" do
    it "does not update the user" do
      patch :update, params: { id: @user.to_param, user: invalid_attributes }
      @user.reload
      expect(@user.username).to eq("testuser")
    end

    it "renders the edit template" do
      patch :update, params: { id: @user.to_param, user: invalid_attributes }
      expect(response).to render_template(:edit)
    end
  end
end

  # Tests for before_action callbacks

  describe "before actions" do
 
    context "when logged in as a different user" do
      let(:other_user) { User.create!(username: "otheruser", email: "otheruser@example.com", password: "password") }

      before do
        allow_any_instance_of(UsersController).to receive(:current_user).and_return(other_user)
      end

      it "redirects from the edit action" do
        get :edit, params: { id: user.to_param }
        expect(response).to redirect_to(user_path(user))
        expect(flash[:alert]).to eq("You can only edit or delete your own account")
      end

      it "redirects from the update action" do
        patch :update, params: { id: user.to_param, user: valid_attributes }
        expect(response).to redirect_to(user_path(user))
        expect(flash[:alert]).to eq("You can only edit or delete your own account")
      end

      it "redirects from the destroy action" do
        delete :destroy, params: { id: user.to_param }
        expect(response).to redirect_to(user_path(user))
        expect(flash[:alert]).to eq("You can only edit or delete your own account")
      end
    end
  end
end
