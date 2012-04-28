class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.string :status,             :default => 'pending'

      t.integer :user_id
      t.timestamps
    end
  end
end
