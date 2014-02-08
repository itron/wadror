require 'spec_helper'

include OwnTestHelper

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "has ratings" do
    let(:beer){ FactoryGirl.create :beer }
    let(:user){ FactoryGirl.create :user, username:"Sykerö" }
    let(:user2){ FactoryGirl.create :user, username:"Erkki" }
    user_ratings = [10, 20, 30]
    user_ratings2 = [11, 21, 31]

    before :each do
      user_ratings.each do |score|
        FactoryGirl.create :rating, score:score, user:user, beer:beer
      end

      user_ratings2.each do |score|
        FactoryGirl.create :rating, score:score, user:user2, beer:beer
      end
    end

    it "only the user's ratings are displayed on his/her page" do
      visit user_path(user)

      user_ratings.each do |score|
        expect(page).to have_content "anonymous #{score}"
      end

      user_ratings2.each do |score|
        expect(page).not_to have_content "anonymous #{score}"
      end
    end

    it "ratings can be deleted" do
      sign_in(username:"Sykerö", password:"Foobar1")

      visit user_path(user)
      expect{
        first(:link, 'delete').click
      }.to change{Rating.count}.from(6).to(5)
    end

    it "favorite beer style is displayed correctly" do
      best_beer = FactoryGirl.create :beer, name:"best", style:"Ultimate"
      FactoryGirl.create :rating, score:50, beer:best_beer, user:user

      visit user_path(user)

      expect(page).to have_content 'Favorite style: Ultimate'
    end

    it "favorite brewery is displayed correctly" do
      best_brewery = FactoryGirl.create :brewery, name:"B"
      best_beer = FactoryGirl.create :beer, name:"best", style:"Ultimate", brewery:best_brewery
      FactoryGirl.create :rating, score:50, beer:best_beer, user:user

      visit user_path(user)

      expect(page).to have_content 'Favorite brewery: B'
    end
  end
end