# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kasoba/version"

Gem::Specification.new do |s|
  s.name        = "kasoba"
  s.version     = Kasoba::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["kasoba"]
  s.email       = ["lacidescharris@hotmail.es", "guilleiguaran@gmail.com"]
  s.homepage    = "https://github.com/guilleiguaran/kasoba"
  s.summary     = %q{Interactive tool for large scale code refactors}
  s.description = %q{Kasoba is a tool meant to assist programmers with large-scale code refactors.}

  s.rubyforge_project = "kasoba"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
