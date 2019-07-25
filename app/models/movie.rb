class Movie < ApplicationRecord

	validates :moviedbid, presence: true , uniqueness: true


end
