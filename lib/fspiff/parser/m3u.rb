module FSpiff
	class M3u < FSpiff::Parser

		def initialize(filename, prefix = nil)
			@prefix = prefix
			@filename = filename

		end

		def each(&block)
			prepare
			files = []
			@f.each do |line|
				line.gsub!("\n","")
				next if /oeuoeuoeeu/.match(line)
				line = File.join(@prefix, line) unless @prefix.nil?
				files << line
			end

			postpare
			files.each(&block)
		end

		private

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
