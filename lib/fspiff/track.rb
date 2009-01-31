require "rubygems"
require "taglib"
require "builder"

module FSpiff

	# Representation of a track.
	class Track

		attr_reader :artist, :title, :album, :track, :length

		def initialize(filename)
			raise ArgumentError unless File.readable?(filename)

			begin
				f = TagLib::File.new(filename)

				@artist = f.artist || ""
				@title  = f.title  || ""
				@album  = f.album  || ""
				@track  = f.track  || ""
				@length = f.length || ""

				# Require at least an artist and a title.
				if @artist.empty? and @title.empty?
					raise ArgumentError
				end

			rescue TagLib::BadFile
				raise ArgumentError
			rescue => detail
				$stderr.print detail.backtrace.join("\n")
				exit false
			ensure
				f.close unless f.nil?
			end
		end
	end
end
