module ApplicationHelper
	class MovieAPI

		BASE_URL = "https://api.themoviedb.org/3/discover/movie"
		API_URL = "?api_key=#{ENV['MOVIEDB_API_KEY']}"
		LANGUAGE_URL = "&language=en-US"
		RELEASEDATE_URL = "&release_date.lte="
		END_URL = "&include_adult=false&include_video=false&page="
		SORT_URL = "&sort_by=popularity.desc"
		SEARCH_URL = "https://api.themoviedb.org/3/search/movie"
		IMAGE_URL = "https://image.tmdb.org/t/p/w185/"



# Choose from one of the many available sort options.

# Allowed Values: , popularity.asc, popularity.desc, release_date.asc, release_date.desc, revenue.asc, revenue.desc, primary_release_date.asc, primary_release_date.desc, original_title.asc, original_title.desc, vote_average.asc, vote_average.desc, vote_count.asc, vote_count.desc
# default: popularity.desc 
		attr_accessor :page
		attr_accessor :search

		def initialize(page = 1, search = "")

			genreURL = "https://api.themoviedb.org/3/genre/movie/list" + API_URL + LANGUAGE_URL
			request = HTTParty.get(genreURL).to_json
			genreList = JSON.parse(request)
			@genreHash = {}
			genreList["genres"].each do |g|
				@genreHash[g["id"]] = g["name"]
			end
			page > 0 ? (@page = page) : (@page = 1)
			@search = search
		end

		def buildURL(page)
			if @search == ""
				fullURL = BASE_URL + API_URL + LANGUAGE_URL + END_URL + page.to_s + SORT_URL + RELEASEDATE_URL + DateTime.now.strftime("%Y-%m-%d")
			else
				fullURL = SEARCH_URL + API_URL + LANGUAGE_URL + "&query=" + @search + END_URL + page.to_s
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
				allMovies.push(movie)
			end
			allMovies
		end


		def getGenre(genreIds)
			genreNames = ""
			genreIds.each do |g|
				genreNames += " | #{@genreHash[g]}"
			end
			genreNames += " |"
			genreNames
		end



	end
end
