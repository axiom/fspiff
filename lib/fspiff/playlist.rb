require "builder"

module FSpiff

	class Playlist
		attr :tracks

		def initialize
			@tracks = []
		end

		def to_s
			albums = {}
			albums.default = []

			@tracks.each do |t|
				albums[t.album] = albums[t.album] + [t]
			end

			buf = albums.map do |k,v|
				b = []
				b << k
				b << "~" * k.length
				v.each do |t|
					b << t.to_s
				end
				b.join("\n")
			end

			buf.join("\n\n")
		end
	end
end
