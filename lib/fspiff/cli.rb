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

				opts.on("-p", "--prefix=directory", "set the prefix for relative filenames") do |p|
					@options[:prefix] = p
				end

				opts.on("-m", "--m3u=playlist", "get relative filenames from a m3u playlist") do |m|
					@options[:parser] = FSpiff::Parsers::M3u.new(m, @prefix)
				end

				opts.on("-x", "--xspf", "print XSPF version of playlist (default)")

				opts.on("-t", "--text", "print plain text version of playlist") do |m|
					@options[:printer] = FSpiff::Printers::Plain.new
				end

				opts.on("-f", "--force", "overwrite output file if it exists") do |f|
					@options[:overwrite] = true
				end

				opts.on("-o", "--out=file", "write output to file (default standard output)") do |m|
					if File.exists?(m) and not @options[:overwrite]
						errmsg("Not overwriting file without -f options.") if File.exists?(m)
						exit false
					end

					@options[:output] = File.open(m, 'w')
				end

				opts.version = VERSION
				opts.release = RELEASE
			end

			@options[:input]   ||= $stdin
			@options[:output]  ||= $stdout
			@options[:parser]  ||= FSpiff::Parsers::Filelist.new(@options[:input], @options[:prefix])
			@options[:printer] ||= FSpiff::Printers::XSPF.new
		end

		def run(a=nil)
			# Treat all extra options as filenames of playlists.
			@files = @optparse.parse(ARGV)

			# Don't read files from terminal, that is tedious.
			if @options[:input].tty?
				puts @optparse.help
				exit false
			end

			@options[:parser].each do |filename|
				begin
					t = Track.new(filename)
					@playlist.tracks << t
				rescue ArgumentError
					errmsg("Could not read metadata from file. Skipping.")
				end
			end

			@options[:output].write(@options[:printer].print(@playlist))
			exit true
		end

		def errmsg(str)
			$stderr.puts(FSpiff::NAME + ": " + str)
		end
	end
end
