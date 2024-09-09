require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(username: "testuser", email: "testuser@example.com", password: "password")
      expect(user).to be_valid
    end

    it "is not valid without a username" do
      user = User.new(username: nil, email: "testuser@example.com", password: "password")
      expect(user).not_to be_valid
    end

    it "is not valid with a too short username" do
      user = User.new(username: "ab", email: "testuser@example.com", password: "password")
      expect(user).not_to be_valid
    end

    it "is not valid with a too long username" do
      user = User.new(username: "a" * 26, email: "testuser@example.com", password: "password")
      expect(user).not_to be_valid
    end

    it "is not valid without an email" do
      user = User.new(username: "testuser", email: nil, password: "password")
      expect(user).not_to be_valid
    end

    it "is not valid with an invalid email format" do
      user = User.new(username: "testuser", email: "invalidemail", password: "password")
      expect(user).not_to be_valid
    end

    it "is not valid with a duplicate email" do
      User.create(username: "user1", email: "testuser@example.com", password: "password")
      user = User.new(username: "user2", email: "testuser@example.com", password: "password")
      expect(user).not_to be_valid
    end

    it "is not valid without a password" do
      user = User.new(username: "testuser", email: "testuser@example.com", password: nil)
      expect(user).not_to be_valid
    end
  end

  describe "callbacks" do
    it "downcases email before saving" do
      user = User.new(username: "testuser", email: "TESTUSER@EXAMPLE.COM", password: "password")
      user.save
      expect(user.reload.email).to eq("testuser@example.com")
    end
  end

  describe "associations" do
    it { should have_many(:articles).dependent(:destroy) }
  end
end
