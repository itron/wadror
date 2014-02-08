class User < ActiveRecord::Base
	include RatingAverage
	extend ActiveSupport::Concern

	has_secure_password
	
	validates :username, uniqueness: true
	validates :username, length: { minimum: 3,
								   maximum: 15 }
	validates :password, length: { minimum: 4 }
	validates_format_of :password, with: /(?=.*[0-9])/, on: :create, message: "must contain at least one number"
	validates_format_of :password, with: /(?=.*[a-z])/, on: :create, message: "must contain at least one lower case letter"
	validates_format_of :password, with: /(?=.*[A-Z])/, on: :create, message: "must contain at least one upper case letter"

	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings

	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships

	def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
  	return nil if ratings.empty?
  	ratings.sort_by{ |rating| 
  		rating.beer.style 
  	}.chunk { |rating|
  		rating.beer.style
  	}.sort_by { |style, ary|
  		ary.inject(0){ |sum, rating| sum += rating.score }.to_f / ary.size
  	}.last[0]
  end

  def favorite_brewery
  	return nil if ratings.empty?
  	ratings.sort_by{ |rating| 
  		rating.beer.brewery
  	}.chunk { |rating|
  		rating.beer.brewery
  	}.sort_by { |brewery, ary|
  		ary.inject(0){ |sum, rating| sum += rating.score }.to_f / ary.size
  	}.last[0]
  end
end
