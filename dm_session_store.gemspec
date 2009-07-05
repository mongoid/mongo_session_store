# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm_session_store}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tony Pitale"]
  s.date = %q{2009-07-05}
  s.email = %q{tpitale@gmail.com}
  s.files = ["README.textile", "Rakefile", "lib/dm_session_store", "lib/dm_session_store/session_store.rb", "lib/dm_session_store/version.rb", "lib/dm_session_store.rb", "test/unit/dm_session_store_test.rb"]
  s.homepage = %q{http://t.pitale.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Database session store using DataMapper in Rails}
  s.test_files = ["test/unit/dm_session_store_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["~> 0.9.11"])
      s.add_runtime_dependency(%q<actionpack>, ["~> 2.3.0"])
    else
      s.add_dependency(%q<dm-core>, ["~> 0.9.11"])
      s.add_dependency(%q<actionpack>, ["~> 2.3.0"])
    end
  else
    s.add_dependency(%q<dm-core>, ["~> 0.9.11"])
    s.add_dependency(%q<actionpack>, ["~> 2.3.0"])
  end
end
