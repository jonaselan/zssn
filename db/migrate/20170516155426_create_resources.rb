class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.integer :point
      t.integer :name

      t.timestamps
    end
  end
end
