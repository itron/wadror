class Beer < ActiveRecord::Base
	include RatingAverage

	validates :name, length: { minimum: 1 }
	validates :style, length: { minimum: 1 }

	belongs_to :brewery
	has_many :ratings, dependent: :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user

	def to_s
		name + " (" + brewery.name + ")"
	end
end
