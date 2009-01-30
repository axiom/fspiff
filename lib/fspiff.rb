require "rubygems"
require "taglib"
require "builder"

module FSpiff

	class Base

		def initialize
			@default = {
				:base = "/srv/music/"
			}
		end

		xspf = Builder::XmlMarkup.new(:target => $stdout, :indent => 1)

		xspf.instruct!

		xspf.playlist do

			xspf.title ""
			xspf.creator ""
			xspf.info ""

			xspf.tracklist do

				ARGF.each do |fn|
					begin
						f = TagLib::File.new(BASE + fn.strip)

						xspf.track do
							xspf.title f.title if f.title
							xspf.creator f.artist if f.artist
							xspf.album f.album if f.album
							xspf.duration f.length * 1000 if f.length
							xspf.trackNum f.track if f.track
						end
					rescue Mahoro::Error
					rescue TagLib::BadFile
					rescue TagLib::BadTag
					ensure
						f.close unless f.nil?
					end
				end

			end
		end
	end
end
