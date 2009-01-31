require 'rake'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rubygems'

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__),'lib')))

require 'lib/fspiff'

task :default => :package

Rake::RDocTask.new do |rd|
	rd.main = "README.rdoc"
	rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end

spec = Gem::Specification.new do |s|
	s.name                  = FSpiff::NAME
	s.version               = FSpiff::VERSION
	s.platform              = Gem::Platform::RUBY
	s.summary               = 'Create XSPF playlists from music files.'
	s.description           = 'Create sharable XSPF playlists with meta data read from music files.'
	s.homepage              = 'http://antiklimax.se/projects/fspiff'
	s.rubyforge_project     = 'fspiff'
	s.author                = 'Johannes Martinsson'
	s.email                 = 'johannes@antiklimax.se'
	s.has_rdoc              = true
	s.extra_rdoc_files      = ['README.rdoc']
	s.files                 = %w{ README.rdoc Rakefile } + Dir[File.join('{bin,lib,data}','**','*')]
	s.executables           = ['fspiff']
	s.require_path          = 'lib'
	s.bindir                = 'bin'
end

Rake::GemPackageTask.new(spec) do |pkg|
	pkg.need_tar_bz2 = true
end
