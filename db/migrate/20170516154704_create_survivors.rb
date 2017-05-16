class CreateSurvivors < ActiveRecord::Migration[5.0]
  def change
    create_table :survivors do |t|
      t.string :name
      t.integer :age
      t.string :gender
      t.string :latitude
      t.string :longitude
      t.boolean :infected
      t.integer :infection_occurrences

      t.timestamps
    end
  end
end
