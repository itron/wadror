class Beer < ActiveRecord::Base
	include RatingAverage

	validates :name, length: { minimum: 1 }
	validates :style, presence: true

	belongs_to :brewery
	belongs_to :style
	has_many :ratings, dependent: :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user

	def to_s
		name + " (" + brewery.name + ")"
	end
end
