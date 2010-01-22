require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mongo_session_store"
    gem.summary = %Q{Rails session store class implemented for MongoMapper}
    gem.email = "nicolas.merouze@gmail.com"
    gem.homepage = "http://github.com/nmerouze/mongo_session_store"
    gem.authors = ["Nicolas Mérouze", "Tony Pitale", "Chris Brickley"]
    
    gem.add_dependency('actioncontroller',  '~> 2.3')
    gem.add_dependency('mongo_mapper', '~> 0.6.1')
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end