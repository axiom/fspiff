module FSpiff
	class Base
		def self.run(parser, printer, output)
			playlist = Playlist.new

			parser.each do |filename|
				begin
					t = Track.new(filename)
					playlist.tracks << t
				rescue ArgumentError
				end
			end

			if playlist.tracks.empty?
				$stderr.puts(FSpiff::NAME + ": could not find any tracks with meta data")
				exit false
			end

			output.write(printer.print(playlist))
			exit true
		end
	end
end
