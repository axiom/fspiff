module FSpiff
	module Parsers

		# Simple parser for M3U playlists, which basically just ignore empty
		# lines and lines starting with '#'.
		class M3u < FSpiff::Parser

			# Filename should be the full path for a m3u playlist. Prefix will
			# be used as a prefix when generating filenames.
			def initialize(filename, prefix = nil)
				@prefix = prefix
				@filename = filename

			end

			# Run the parser, but fail completely if the file can not be
			# opened for reading.
			def each(&block)
				prepare
				files = []
				@f.each do |line|
					line.gsub!("\n","")

					# Ignore these lines since they does not contain a
					# filename.
					next if /^#/.match(line)

					# Skip empty lines as well.
					next if /^\s*$/.match(line)

					line = File.join(@prefix, line) unless @prefix.nil?
					files << line
				end

				postpare
				files.each(&block)
			end

			private

			# Try to open @filename for reading, or fail completely.
			def prepare
				begin
					@f = File.open(@filename, 'r')
				rescue
					$stderr.puts(FSpiff::NAME + ": could not open file for reading.")
					@f.close unless @f.nil?
					exit false
				end
			end

			def postpare
				@f.close unless @f.nil?
			end

		end
	end
end
