require 'fspiff/base'
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
	NAME    = 'fspiff'
	WWW     = 'http://antiklimax.se/projects/fspiff'
	VERSION = '0.1'
	RELEASE = `git-rev-parse --short HEAD`.gsub("\n",'')
end
