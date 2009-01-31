module FSpiff
	module Parsers

		# Simple parser for M3U playlists, which basically just ignore empty
		# lines and lines starting with '#'.
		class M3u < FSpiff::Parser

			# Filename should be the full path for a m3u playlist. Prefix will
			# be used as a prefix when generating filenames.
			def initialize(filename, prefix = nil)
				@prefix = prefix
				@filenames = filename.to_a
			end

			# Run the parser, but fail completely if the file can not be
			# opened for reading.
			def each(&block)
				files = []

				@filenames.each do |filename|
					f = open_file(filename)
					f.each do |line|
						line.gsub!("\n","")

						# Ignore these lines since they does not contain a
						# filename.
						next if /^#/.match(line)

						# Skip empty lines as well.
						next if /^\s*$/.match(line)

						line = File.join(@prefix, line) unless @prefix.nil?
						files << line
					end
					close_file(f)
				end

				files.each(&block)
			end

			private

			# Try to open @filename for reading, or fail completely.
			def open_file(filename = nil)
				filename ||= @filenames.shift

				begin
					f = File.open(filename, 'r')
				rescue
					$stderr.puts(FSpiff::NAME + ": could not open file for reading.")
					f.close unless f.nil?
					exit false
				end

				f
			end

			def close_file(filename)
				filename.close unless filename.nil?
			end

		end
	end
end
