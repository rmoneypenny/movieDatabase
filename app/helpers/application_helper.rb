module ApplicationHelper
	
	class MovieAPI

		BASE_URL = "https://api.themoviedb.org/3/"
		API_URL = "?api_key=#{ENV['MOVIEDB_API_KEY']}"
		LANGUAGE_URL = "&language=en-US"
		RELEASEDATE_URL = "&release_date.lte="
		END_URL = "&include_adult=false&include_video=false&page="
		SORT_URL = "&sort_by=popularity.desc"
		IMAGE_URL = "https://image.tmdb.org/t/p/w185/"


		attr_accessor :page
		attr_accessor :search
		@request_hash = {}
		
		def initialize(page = 1, search = "")

			page > 0 ? (@page = page) : (@page = 1)
			@search = search
		end

		def buildURL(page)
			if @search == ""
				fullURL = BASE_URL + "discover/movie" + API_URL + LANGUAGE_URL + END_URL + page.to_s + SORT_URL + RELEASEDATE_URL + DateTime.now.strftime("%Y-%m-%d")
			else
				fullURL = BASE_URL + "search/movie" + API_URL + LANGUAGE_URL + "&query=" + @search + END_URL + page.to_s
			end
			request = HTTParty.get(fullURL).to_json
			@request_hash = JSON.parse(request)
		end

		def movieList
			self.buildURL(@page)
			allMovies = []
			@request_hash["results"].each do |t|
			review = Review.new
				movie = []
				movie.push(t["title"])

				begin
					releaseDate = DateTime.parse(t["release_date"])
					movie.push(releaseDate.strftime("%b %e, %Y"))
				rescue ArgumentError
				   movie.push("Release Date Uknown")
				end

				movie.push(self.getGenre(t["genre_ids"]))
				if t["poster_path"]
					movie.push(IMAGE_URL + t["poster_path"])
				else
					movie.push("https://dummyimage.com/185x308/e0d7e0/fff&text=No+Poster+Available")
				end
				movie.push(t["id"].to_s)
				movie.push(review.getReviews(t["id"],3))
				movie.push(review.avgScore(t["id"]))
				movie.push(review.userReviewIDs(t["id"]))
				allMovies.push(movie)
			end
			#[title, release date, [genres], poster path, moviedbid, Reviews, avgScore, userReviewIDs]
			allMovies
		end


		def getGenre(genreIds)
			genreURL = BASE_URL + "genre/movie/list" + API_URL + LANGUAGE_URL
			request = HTTParty.get(genreURL).to_json
			genreList = JSON.parse(request)
			@genreHash = {}

			genreList["genres"].each do |g|
				@genreHash[g["id"]] = g["name"]
			end
			
			genreNames = []
			genreIds.each do |g|
				genreNames.push(@genreHash[g])
			end
			genreNames
		end

		def getMovieInfo(moviedbid)
			searchURL = BASE_URL + "movie/" + moviedbid + API_URL + LANGUAGE_URL
			request = HTTParty.get(searchURL).to_json
			movieHash = JSON.parse(request)
			movieInfo = []
			genreNames = []
			movieInfo.push(moviedbid)
			movieInfo.push(movieHash["title"])
			movieInfo.push(Date.parse(movieHash["release_date"]))
			movieHash["genres"].each do |g|
				genreNames.push(g["name"])
			end
			movieInfo.push(genreNames)
			movieInfo.push(IMAGE_URL + movieHash["poster_path"])
			#[moviedbid, title, release_date, [genres], poster]
			movieInfo
		end



	end
end
