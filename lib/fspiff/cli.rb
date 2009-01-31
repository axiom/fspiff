require 'optparse'

module FSpiff

	# Provides a command line interface to fspiff.
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

				opts.separator(" ")

				opts.on('-w', "--printer=plain", "set printer, default is xspf") do |o|
					@options[:printer] = o.to_sym
				end

				opts.on('-r', "--parser=filelist", "set parser, default is filelist") do |o|
					@options[:parser] = o.to_sym
				end

				opts.separator(" ")

				opts.on("-t", "--title=playlist-title", "set title of playlist") do |o|
					@options[:title] = o
				end

				opts.on("-i", "--info=playlist-info", "set info of playlist") do |o|
					@options[:info] = o
				end

				opts.on("-p", "--prefix=directory", "set the prefix for relative filenames") do |p|
					@options[:prefix] = p
				end

				# More tricky stuff.

				opts.separator(" ")

				opts.on("-o", "--out=file", "write output to file (default standard output)") do |m|
					@options[:outfile] = m
					@options[:output] = :file
				end

				opts.on("-f", "--force", "overwrite output file if it exists") do |f|
					@options[:overwrite] = true
				end

				@options[:input] ||= $stdin unless $stdin.tty?

				opts.program_name = FSpiff::NAME
				opts.version      = FSpiff::VERSION
				opts.release      = FSpiff::RELEASE
				opts.banner = "Usage: #{opts.program_name} [options] [filename]"
			end
		end

		# Run fspiff with the options specified in `args'.
		def run(args=nil)
			parse_options(args)
			handle_options

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

		protected

		def parse_options(args)
			begin
				@options[:extra] = @optparse.order(args)
			rescue OptionParser::InvalidOption
				bail("invalid option")
			end

			@options[:input]   ||= @options[:extra]
			@options[:output]  ||= :stdout
			@options[:parser]  ||= :plain
			@options[:printer] ||= :xspf
		end

		def handle_options
			case @options[:parser]
			when :m3u
				@options[:parser] = FSpiff::Parsers::M3u.new(@options[:extra].shift, @options[:prefix])
			when :plain
				@options[:parser] = FSpiff::Parsers::Filelist.new(@options[:input], @options[:prefix])
			else
				bail("unknown parser")
			end

			case @options[:printer]
			when :plain
				@options[:printer] = FSpiff::Printers::Plain.new
			when :xspf
				@options[:printer]= FSpiff::Printers::XSPF.new(@options[:title], @options[:info])
			else
				bail("unknown printer")
			end

			case @options[:output]
			when :file
				f = @options[:outfile]
				if File.exists?(f) and not @options[:overwrite]
					errmsg("not overwriting existing files without the `--force' flag")
					puts @options[:overwrite]
					exit false
				end

				@options[:output] = File.open(f, 'w')
			when :stdout
				@options[:output] = $stdout
			end
		end

		# Prints `str' prefixed with the application name to stderr.
		def errmsg(str, prefix = true)
			str = FSpiff::NAME + ": " + str if prefix
			$stderr.puts(str)
		end

		def trymsg
			errmsg("Try `#{FSpiff::NAME} --help' for more information.", false)
		end

		def bail(str)
			errmsg(str)
			trymsg
			exit false
		end
	end
end
