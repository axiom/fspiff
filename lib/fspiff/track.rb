require "rubygems"
require "taglib"
require "builder"

module FSpiff

	class Track

		attr_reader :artist, :title, :album, :track

		def initialize(filename)
			@artist, @title, @album, @track = ["","","",""]

			begin
				f = TagLib::File.new(filename)

				@artist = f.artist
				@title  = f.title
				@album  = f.album
				@track  = f.track

			rescue => detail
				$stderr.print detail.backtrace.join("\n")
				exit false
			ensure
				f.close unless f.nil?
			end
		end

		def to_s
			@artist + " - " + @title
		end
	end
end
