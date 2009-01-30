require 'fspiff/cli'
require 'fspiff/track'
require 'fspiff/playlist'

module FSpiff
	VERSION = 0.1
	RELEASE = `git branch|grep -e "^\*"|cut -d' ' -f2`.gsub("\n","")
end
