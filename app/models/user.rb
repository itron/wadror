class User < ActiveRecord::Base
	include RatingAverage

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
end
