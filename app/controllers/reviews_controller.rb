class ReviewsController < ApplicationController

	def create
		if !Movie.exists?(moviedbid: params[:moviedbid])
			movieAPI = MovieAPI.new
			movieInfo = movieAPI.getMovieInfo(params[:moviedbid])
			movieInfo[3].each do |m|
				Genre.create(moviedbid: params[:moviedbid], name: m)
			end
			movie = Movie.new(moviedbid: params[:moviedbid], title: movieInfo[1], releasedate: movieInfo[2])
			movie.save
		end

		puts params
		#review = Review.new()

	end

end


    # t.integer "user_id"
    # t.integer "moviedbid"
    # t.string "comment"
    # t.date "date"
    # t.integer "score"