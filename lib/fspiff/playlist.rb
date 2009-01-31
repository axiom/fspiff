require "builder"

module FSpiff

	# Just a wrapper around a array of tracks.
	class Playlist
		attr :tracks

		def initialize
			@tracks = []
		end
	end
end
