class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :moviedbid
      t.string :comment
      t.date :date
      t.integer :score

      t.timestamps
    end
  end
end
