class RemoveGenreFromMovies < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :genre, :string
  end
end
