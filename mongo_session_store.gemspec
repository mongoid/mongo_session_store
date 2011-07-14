MONGO_VERS = '1.3.1' unless defined? MONGO_VERS

Gem::Specification.new do |s|
  s.name = %q{mongo_session_store}
  s.version = `cat VERSION`

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nicolas M\303\251rouze", "Tony Pitale", "Chris Brickley"]
  s.date = %q{2010-10-13}
  s.email = %q{nicolas.merouze@gmail.com}
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "README.md",
     "lib/mongo_session_store.rb",
     "lib/mongo_session_store/mongo_mapper.rb",
     "lib/mongo_session_store/mongoid.rb"
  ]
  s.homepage = %q{http://github.com/nmerouze/mongo_session_store}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Rails session store class implemented for MongoMapper and Mongoid}

  s.add_dependency(%q<actionpack>, ["> 3.0"])
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'mongo_mapper', '>= 0.9.0'
  s.add_development_dependency 'mongoid',      '>= 2.0'
  s.add_development_dependency 'mongo',         MONGO_VERS
  s.add_development_dependency 'bson_ext',      MONGO_VERS
end

