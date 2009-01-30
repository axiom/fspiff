require 'optparse'

module FSpiff

	class CLI

		def initialize
			@playlist = Playlist.new

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

				opts.on("-m", "--m3u=playlist", "get relative filenames from a m3u playlist")
				opts.on("-p", "--prefix=directory", "set the prefix for relative filenames")
				opts.version = VERSION
				opts.release = RELEASE
			end
		end

		def run(a=nil)
			# Treat all extra options as filenames of playlists.
			@files = @optparse.parse(ARGV)
			puts @files

			# Require some instructions or filenames on stdin.
			if ARGV.length == 0 and $stdin.tty?
				puts @optparse.help
				# exit false
			end

			unless $stdin.tty?
				$stdin.each do |line|
					filename = line.gsub("\n","")
					unless filename.nil?
						@playlist.tracks << Track.new(filename)
					end
				end
			end

			puts @playlist.to_s
		end
	end
end
