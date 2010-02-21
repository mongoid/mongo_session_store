require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mongo_session_store"
    gem.summary = %Q{Rails session store class implemented for MongoMapper and Mongoid}
    gem.email = "nicolas.merouze@gmail.com"
    gem.homepage = "http://github.com/nmerouze/mongo_session_store"
    gem.authors = ["Nicolas Mérouze", "Tony Pitale", "Chris Brickley"]
    gem.files = Dir["README.md", "lib/**/*"]
    
    gem.add_dependency 'actionpack',  '~> 2.3'
    gem.add_development_dependency 'mongo_mapper', '>= 0.6.1'
    gem.add_development_dependency 'mongoid', '~> 1.0'
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end