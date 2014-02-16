class AddStyleIdToBeers < ActiveRecord::Migration
  def change
  	add_column :Beers, :style_id, :integer
  end
end
