require 'fspiff/cli'
require 'fspiff/track'
require 'fspiff/playlist'
require 'fspiff/parser'
require 'fspiff/parser/m3u'

module FSpiff
	NAME = "fspiff"
	VERSION = 0.1
	RELEASE = `git branch|grep -e "^\*"|cut -d' ' -f2`.gsub("\n","")
end
