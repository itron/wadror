require 'spec_helper'
include OwnTestHelper

describe "Beer" do
	let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

	before :each do
		FactoryGirl.create :user
		sign_in(username:"Pekka", password:"Foobar1")
		visit new_beer_path
	end

	describe "when given a valid name" do
		it "is saved" do
			fill_in('beer_name', with:'Aloha')
			expect{
				click_button 'Create Beer'
			}.to change{Beer.count}.from(0).to(1)
		end
	end

	describe "When given an invalid name" do
		before :each do
			click_button 'Create Beer'
		end

		it "is not saved" do
			expect(Beer.count).to eq(0)
		end

		it "the user stays on the creation page" do
			expect(page).to have_content 'New beer'
		end

		it "an error is printed" do
			expect(page).to have_content 'Name is too short'
		end
	end
end