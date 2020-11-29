class AddUserRefToUrls < ActiveRecord::Migration[6.0]
  def change
    add_reference :urls, :user, null: true, foreign_key: true
  end
end
