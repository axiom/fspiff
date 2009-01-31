module FSpiff

	# A parser is responsible for providing filenames.
	class Parser

		# This method must be implemented by any subclasses, it should behave
		# like an array of filenames.
		def each(&block)
			raise NotImplementedError
		end
	end
end
