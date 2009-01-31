module FSpiff
	module Parsers

		# Very simple parser that just echos each line from `input` while also
		# removing the newline character.
		class Filelist < FSpiff::Parser

			# Input should be something that behave like an array of lines of
			# filenames. E.g. $stdin, or a file handle to a file with
			# filenames on each line.
			def initialize(input, prefix=nil)
				@input = input
			end

			def each(&block)
				@input.map do |line|
					line.gsub("\n","")
				end.each(&block)
			end
		end
	end
end
