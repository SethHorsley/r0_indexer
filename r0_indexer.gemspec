Gem::Specification.new do |spec|
  spec.name = "r0_indexer"
  spec.version = "0.1.0"
  spec.authors = ["Your Name"]
  spec.email = ["your@email.com"]

  spec.summary = "Rails repository indexer"
  spec.description = "Index and query Rails views, controllers, and routes"
  spec.homepage = "https://github.com/yourusername/r0_indexer"
  spec.license = "MIT"

  spec.files = Dir["{lib,bin}/**/*", "README.md", "LICENSE.txt"]
  spec.bindir = "bin"
  spec.executables = ["r0"]
  spec.require_paths = ["lib"]

  spec.add_dependency "sqlite3", ">= 1.4", "< 3.0"
  spec.add_dependency "thor", "~> 1.2"
  spec.add_development_dependency "rake", "~> 13.0"
end
