require "rubygems"
require "taglib"
require "builder"

module FSpiff

	class Track

		attr_reader :artist, :title, :album, :track

		def initialize(filename=nil)
			@artist, @title, @album, @track = [nil,nil,nil,nil]

			begin
				f = TagLib::File.new(filename)

				@artist = f.artist
				@title  = f.title
				@album  = f.album
				@track  = f.track

			rescue Mahoro::Error
			rescue TagLib::BadFile
			rescue TagLib::BadTag
				$stderr.puts("FUCK")
			ensure
				f.close unless f.nil?
			end
		end

		def to_s
			@artist + " - " + @title
		end
	end
end
