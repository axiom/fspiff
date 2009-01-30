require "rubygems"
require "taglib"
require "builder"

module FSpiff

	class Track

		attr_reader :artist, :title, :album, :track

		def initialize(filename)
			raise ArgumentError unless File.readable?(filename)

			begin
				f = TagLib::File.new(filename)

				@artist = f.artist
				@title  = f.title
				@album  = f.album
				@track  = f.track

			rescue => detail
				$stderr.print detail.backtrace.join("\n")
				EXIT false
			ensure
				f.close unless f.nil?
			end

			@artist ||= ""
			@title  ||= ""
			@album  ||= ""
			@track  ||= ""

		end

		def to_s
			@artist + " - " + @title
		end
	end
end
