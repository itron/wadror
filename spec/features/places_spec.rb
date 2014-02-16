require 'spec_helper'

describe "Places" do

  before :each do
    Rails.cache.clear
  end

	it "if no places are returned, a notice is shown on the page" do
		BeermappingApi.stub(:places_in).with("kumpula").and_return(
        []
    )

    search_for_kumpula()

    expect(page).to have_content 'No locations in kumpula city'
	end

  it "if one is returned by the API, it is shown on the page" do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:id => 1, :name => "Oljenkorsi") ]
    )

    search_for_kumpula()

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the API, they are shown on the page" do
  	names = ["one", "two", "three"]
  	
  	places = names.inject([]) do |set, name|
  		set << Place.new(:id => 1, :name => name)
  	end

  	BeermappingApi.stub(:places_in).with("kumpula").and_return(
  		places
  	)

  	search_for_kumpula()

  	names.each{ |name|
  		expect(page).to have_content name
  	}
  end

end

def search_for_kumpula()
	visit places_path
  fill_in('city', with: 'kumpula')
  click_button "Search"
end
