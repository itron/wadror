class Brewery < ActiveRecord::Base
	include RatingAverage

  validates :name, length: { minimum: 1 }
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                   only_integer: true }
  validate :max_year, on: :create
	
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers

  def max_year
    errors.add(:year, "must be less or equal to #{Date.today.year}") unless year <= Date.today.year
  end

	def print_report
    	puts self.name
    	puts "established at year #{year}"
    	puts "number of beers #{beers.count}"
    	puts "number of ratings #{ratings.count}"
  end

  def restart
    self.year = 2014
    puts "changed year to #{year}"
  end
end
