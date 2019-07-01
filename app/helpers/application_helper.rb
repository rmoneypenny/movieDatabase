module ApplicationHelper
	class MovieAPI

		BASE_URL = "https://api.themoviedb.org/3/discover/movie"
		API_URL = "?api_key=#{ENV['MOVIEDB_API_KEY']}"
		SEARCH_URL = "&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&release_date.gte="

		def buildURL
			twoMonths = (DateTime.now - 1.month).strftime("%Y-%m-%d")
			fullURL = BASE_URL + API_URL + SEARCH_URL + twoMonths
			
			request = HTTParty.get(fullURL).to_json
			@request_hash = JSON.parse(request)

		end

		def movieList
			self.buildURL
			@request_hash["results"].each do |t|
				puts t["title"]
			end

		end


	end
end
