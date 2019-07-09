module ApplicationHelper
	class MovieAPI

		BASE_URL = "https://api.themoviedb.org/3/discover/movie"
		API_URL = "?api_key=#{ENV['MOVIEDB_API_KEY']}"
		SEARCH_URL = "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page="
		RELEASE_DATE = "&release_date.gte="

		attr_accessor :page

		def initialize(page = 1)

			genreURL = "https://api.themoviedb.org/3/genre/movie/list" + API_URL + "&language=en-US"
			request = HTTParty.get(genreURL).to_json
			genreList = JSON.parse(request)
			@genreHash = {}
			genreList["genres"].each do |g|
				@genreHash[g["id"]] = g["name"]
			end
			page > 0 ? (@page = page) : (@page = 1)
		end

		def buildURL(page)
			twoMonths = (DateTime.now - 1.month).strftime("%Y-%m-%d")
			fullURL = BASE_URL + API_URL + SEARCH_URL + page.to_s# + RELEASE_DATE + twoMonths
			
			request = HTTParty.get(fullURL).to_json
			@request_hash = JSON.parse(request)
		end

		def movieList
			self.buildURL(@page)
			allMovies = []
			@request_hash["results"].each do |t|
				movie = []
				movie.push(t["title"])
				movie.push(t["release_date"])
				movie.push(self.getGenre(t["genre_ids"]))
				movie.push(t["poster_path"])
				allMovies.push(movie)
			end
			allMovies
		end


		def getGenre(genreIds)
			genreNames = []
			genreIds.each do |g|
				genreNames.push(@genreHash[g])
			end
			genreNames
		end



	end
end
