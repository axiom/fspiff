require "rubygems"
require "taglib"
require "builder"

module FSpiff
	module Printers

		# This printer produces XSPF output.
		class XSPF < FSpiff::Printer

			def initialize(title = nil, info = nil)
				@title = title || ""
				@creator = FSpiff::NAME + " " + FSpiff::WWW
				@info = info || ""
			end

			def print(playlist)
				buffer = ""
				xspf = Builder::XmlMarkup.new(:target => buffer, :indent => 4)

				xspf.instruct!

				xspf.playlist :version => "1", :xmlns => "http://xspf.org/ns/0/" do

					xspf.title @title
					xspf.creator @creator
					xspf.info @info

					# FIXME: Should be formatted as XML schema dateTime.
					xspf.date Time.now.utc

					xspf.trackList do

						playlist.tracks.each do |t|
							xspf.track do
								xspf.title t.title if t.title
								xspf.creator t.artist if t.artist
								xspf.album t.album if t.album
								xspf.duration t.length * 1000 if t.length
								xspf.trackNum t.track if t.track
							end
						end
					end
				end

				buffer
			end
		end
	end
end
