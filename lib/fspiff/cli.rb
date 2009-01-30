require 'optparse'

module FSpiff

	class CLI

		def initialize
			@playlist = Playlist.new
			@input = $stdin

			@options = {}
			@optparse = OptionParser.new do |opts|
				opts.on("-h", "--help", "show this help message and quit") do
					puts opts.help
					exit true
				end

				opts.on("-v", "--version", "show version information and quit") do
					puts opts.ver
					exit true
				end

				opts.on("-p", "--prefix=directory", "set the prefix for relative filenames") do |p|
					@prefix = p
				end

				opts.on("-m", "--m3u=playlist", "get relative filenames from a m3u playlist") do |m|
					@parser = M3u.new(m, @prefix)
				end

				opts.version = VERSION
				opts.release = RELEASE
			end
		end

		def run(a=nil)
			# Treat all extra options as filenames of playlists.
			@files = @optparse.parse(ARGV)

			# Require some instructions or filenames on stdin.
			if ARGV.length == 0 and $stdin.tty?
				puts @optparse.help
				# exit false
			end

			@parser.each do |filename|
				t = Track.new(filename)

				if t.nil?
					$stderr.puts("Could not read metadata from file. (" + filename + ")")
					next
				end

				@playlist.tracks << t
			end

			puts @playlist.to_s
		end
	end
end
