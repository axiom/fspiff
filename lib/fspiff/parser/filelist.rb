module FSpiff
	module Parsers
		class Filelist < FSpiff::Parser
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
