module ApplicationHelper
	class MovieAPI

		BASE_URL = "https://api.themoviedb.org/3/discover/movie"
		API_URL = "?api_key=#{ENV['MOVIEDB_API_KEY']}"
		LANGUAGE_URL = "&language=en-US"
		RELEASEDATE_URL = "&release_date.lte="
		END_URL = "&include_adult=false&include_video=false&page="
		SEARCH_URL = "https://api.themoviedb.org/3/search/movie"

		attr_accessor :page
		attr_accessor :category
		attr_accessor :search
		#&sort_by=popularity.desc
		#release_date.desc
		#popularity.desc

		def initialize(page = 1, search = "")

			genreURL = "https://api.themoviedb.org/3/genre/movie/list" + API_URL + LANGUAGE_URL
			request = HTTParty.get(genreURL).to_json
			genreList = JSON.parse(request)
			@genreHash = {}
			genreList["genres"].each do |g|
				@genreHash[g["id"]] = g["name"]
			end
			page > 0 ? (@page = page) : (@page = 1)
			@category = "&sort_by=popularity.desc"
			@search = search
		end

		def buildURL(page)
			if @search == ""
				fullURL = BASE_URL + API_URL + LANGUAGE_URL + END_URL + page.to_s + RELEASEDATE_URL + DateTime.now.strftime("%Y-%m-%d")
			else
				fullURL = SEARCH_URL + API_URL + "&query=" + @search
			end

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

		def setCategory(category)
			case category
			when "Title"
				@category = "&sort_by=original_title.desc"
			when "Release Date"
				@category = "&sort_by=release_date.desc"
			when "Genre"
				@category = "&sort_by=original_title.desc"
			end

		end


	end
end
