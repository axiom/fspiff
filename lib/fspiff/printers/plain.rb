module FSpiff
	module Printers
		class Plain < FSpiff::Printer

			def print(playlist)
				albums = {}
				albums.default = []

				playlist.tracks.each do |t|
					albums[t.album || "unknown"] = albums[t.album] + [t]
				end

				buf = albums.map do |k,v|
					b = []
					b << k
					b << "~" * k.length
					v.each do |t|
						b << t.to_s
					end
					b.join("\n")
				end

				buf.join("\n\n")
			end

		end
	end
end
