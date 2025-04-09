class CreateMovies < ActiveRecord::Migration[8.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :year
      t.string :genre
      t.text :description

      t.timestamps
    end
  end
end
