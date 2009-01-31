module FSpiff

	# A printer is responsible for formatting the resulting output of a
	# playlist.
	class Printer

		# Subclasses must implement this method, and it should return a string
		# of the formatted playlist.
		def print(playlist)
			raise NotImplementedError
		end
	end
end
