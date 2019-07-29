require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  
  test "successful creation" do
  	movie = Movie.new(moviedbid: 5, title: "John Wick 4", releasedate: DateTime.now.to_date)
    assert movie.save
  end
  
  test "no movie id" do
  	movie = Movie.new(title: "John Wick 4", releasedate: DateTime.now.to_date)
    assert_not movie.save
  end

  test "existing movie id" do
  	movie = Movie.new(moviedbid: 1, title: "John Wick 4", releasedate: DateTime.now.to_date)
    assert_not movie.save
  end

end

    # t.integer "moviedbid"
    # t.string "title"
    # t.date "releasedate"