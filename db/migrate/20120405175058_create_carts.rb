class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :user_id
      t.integer :address_id
      t.integer :store_id
      t.timestamps
    end
  end
end
