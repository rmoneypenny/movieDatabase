class CreateReviewGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :review_genres do |t|
      t.references :review, foreign_key: true
      t.references :genre, foreign_key: true

      t.timestamps
    end
  end
end
