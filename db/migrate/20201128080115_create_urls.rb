class CreateUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :urls do |t|
      t.string :name
      t.text :url
      t.string :short_url
      t.integer :click_count
      t.timestamp :expiration

      t.timestamps
    end
  end
end
