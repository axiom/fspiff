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

				opts.on("-t", "--title=playlist-title", "set title of playlist") do |o|
					@options[:title] = o
				end

				opts.on("-i", "--info=playlist-info", "set info of playlist") do |o|
					@options[:info] = o
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
						errmsg("not overwriting existing files without the `--force' flag") if File.exists?(m)
						exit false
					end

					@options[:output] = File.open(m, 'w')
				end

				@options[:input] ||= $stdin unless $stdin.tty?

				opts.version = VERSION
				opts.release = RELEASE
			end
		end

		def run(a=nil)
			begin
				# Treat all extra options as filenames of playlists.
				@files = @optparse.order(ARGV)
			rescue OptionParser::InvalidOption
				errmsg("invalid option")
				errmsg("Try `#{FSpiff::NAME} --help' for more information.", false)
				exit false
			end

			@options[:input] ||= @files

			# Don't read files from terminal, that is tedious.
			if @options[:input].kind_of?(Array) and @options[:input].empty?
				errmsg("no input files")
				errmsg("Try `#{FSpiff::NAME} --help' for more information.", false)
				exit false
			end

			@options[:input]   ||= @files
			@options[:output]  ||= $stdout
			@options[:parser]  ||= FSpiff::Parsers::Filelist.new(@options[:input], @options[:prefix])
			@options[:printer] ||= FSpiff::Printers::XSPF.new(@options[:title], @options[:info])

			@options[:parser].each do |filename|
				begin
					t = Track.new(filename)
					@playlist.tracks << t
				rescue ArgumentError
				end
			end

			if @playlist.tracks.empty?
				errmsg("could not find any tracks with meta data")
				exit false
			end

			@options[:output].write(@options[:printer].print(@playlist))
			exit true
		end

		def errmsg(str, prefix = true)
			str = FSpiff::NAME + ": " + str if prefix
			$stderr.puts(str)
		end
	end
end
