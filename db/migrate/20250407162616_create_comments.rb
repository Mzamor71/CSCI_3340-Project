class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :rating, null: false, foreign_key: true
      t.text :comment_text

      t.timestamps
    end
  end
end
