require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/dm_session_store/version'

task :default => :test

spec = Gem::Specification.new do |s|
  s.name            = 'dm_session_store'
  s.version         = DmSessionStore::Version.to_s
  s.summary         = "Database session store using DataMapper in Rails"
  s.author          = 'Tony Pitale'
  s.email           = 'tpitale@gmail.com'
  s.homepage        = 'http://t.pitale.com'
  s.files           = %w(README.textile Rakefile) + Dir.glob("lib/**/*")
  s.test_files      = Dir.glob("test/**/*_test.rb")
  
  s.add_dependency('dm-core', '>= 0.9.11')
  s.add_dependency('actionpack', '>= 2.3.0')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc 'Generate the gemspec to serve this Gem from Github'
task :github do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

begin
  require 'rcov/rcovtask'
  
  desc "Generate RCov coverage report"
  Rcov::RcovTask.new(:rcov) do |t|
    t.test_files = FileList['test/**/*_test.rb']
    t.rcov_opts << "-x lib/dm_session_store.rb -x lib/dm_session_store/version.rb"
  end
rescue LoadError
  nil
end

task :default => 'test'
