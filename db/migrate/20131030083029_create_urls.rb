class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.belongs_to :user
      t.string :long_url
      t.string :longer_url
      t.integer :click_count

      t.timestamps
    end
  end
end
