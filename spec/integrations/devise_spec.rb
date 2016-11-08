require "rails_helper"

describe Devise::SessionsController, :type => :request do
  def create_user
    post "/users", {
       "user[email]"                 => "person@example.com",
       "user[password]"              => "secret",
       "user[password_confirmation]" => "secret"
    }
  end

  def sign_in
    post "/users/sign_in", {
       "user[email]"                 => "person@example.com",
       "user[password]"              => "secret",
       "user[password_confirmation]" => "secret"
    }
  end

  def sign_out
    delete "/users/sign_out"
  end

  def expect_to_be_signed_in
    expect(controller.user_signed_in?).to eq(true)
    get "/"
    expect(response.body.squish).to include "You are signed in as person@example.com"
  end

  def expect_to_not_be_signed_in
    expect(controller.user_signed_in?).to eq(false)
    get "/"
    expect(response.body.squish).to include "You are signed out"
  end

  it "creates a user" do
    expect do
      create_user
      expect(response.status).to eq(302)
    end.to change { User.count }.from(0).to(1)

    get response.redirect_url
    expect(response.body.squish).to include \
      "You are signed in as person@example.com",
      "You have signed up successfully"
  end

  describe "user session" do
    describe "sign out" do
      before do
        create_user
        expect_to_be_signed_in
      end

      it "signs out user" do
        sign_out

        expect(response.status).to eq(302)
        expect_to_not_be_signed_in
        expect(response.body.squish).to include "Signed out successfully"
      end
    end

    describe "sign in" do
      before do
        create_user
        sign_out
        expect_to_not_be_signed_in
      end

      it "signs in user" do
        sign_in

        expect(response.status).to eq(302)
        expect_to_be_signed_in
        expect(response.body.squish).to include "Signed in successfully"
      end
    end
  end

  describe "session_store" do
    subject { Rails.application.config.session_store.session_class.to_s }

    it "uses the mongo #{mongo_orm} session store class" do
      expect(subject).to eq \
        "ActionDispatch::Session::#{mongo_orm.camelize}Store::Session"
    end
  end

  describe "sessions collection" do
    let(:collection) { test_database["sessions"] }

    it "creates a record in the sessions collection" do
      expect do
        create_user
      end.to change { collection.find.count }.from(0).to(1)
    end

    describe "custom collection" do
      before { MongoSessionStore.collection_name = "dance_parties" }
      after { MongoSessionStore.collection_name = "sessions" }
      let(:collection) { test_database["dance_parties"] }

      it "creates a record in the custom sessions collection" do
        expect do
          create_user
        end.to change { collection.find.count }.from(0).to(1)
      end
    end
  end
end
