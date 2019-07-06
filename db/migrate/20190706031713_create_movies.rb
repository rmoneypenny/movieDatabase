class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.integer :moviedbid
      t.string :title
      t.date :releasedate
      t.string :genre

      t.timestamps
    end
  end
end
