require 'fspiff/cli'
require 'fspiff/track'
require 'fspiff/playlist'
require 'fspiff/parser'
require 'fspiff/parsers/m3u'
require 'fspiff/parsers/filelist'
require 'fspiff/printer'
require 'fspiff/printers/plain'
require 'fspiff/printers/xspf'

module FSpiff
	NAME = "fspiff"
	VERSION = 0.1
	RELEASE = `git branch|grep -e "^\*"|cut -d' ' -f2`.gsub("\n","")
end
