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

		Review.create(user_id: current_user.id, moviedbid: params[:moviedbid], comment: params[:comment], date: DateTime.now.to_date, score: params[:score])
		redirect_to movies_path
	end

end

