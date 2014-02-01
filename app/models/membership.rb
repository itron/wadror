class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :beer_club

	validate :unique_membership, on: :create

	def unique_membership
		@m = Membership.find_by(user_id: user_id, beer_club_id: beer_club_id)


		errors.add(:user_id, "already has a membership with this club!") if not @m.nil?
	end
end
