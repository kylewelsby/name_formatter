# -*- encoding: utf-8 -*-
# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)
require 'name_formatter/version'

Gem::Specification.new do |spec|
  spec.name          = "name_formatter"
  spec.version       = NameFormatter::VERSION.dup
  spec.authors       = ["Kyle Welsby"]
  spec.email         = ["kyle@mekyle.com"]

  spec.summary       = %q{A robust name parsing and formatting library for Ruby}
  spec.description   = %q{NameFormatter provides advanced name parsing and formatting capabilities,
                          handling personal names from various cultures, company names, and names
                          with prefixes and suffixes. It correctly formats particles, preserves
                          appropriate capitalization, and is Unicode-aware.}
  spec.homepage      = "https://github.com/kylewelsby/name_formatter"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "https://github.com/kylewelsby/name_formatter"
  # spec.metadata["documentation_uri"] = "https://github.com/kylewelsby/name_formatter"
  spec.metadata["changelog_uri"] = "https://github.com/kylewelsby/name_formatter/blob/main/CHANGELOG.md"
  spec.metadata['funding_uri'] = "https://github.com/sponsors/kylewelsby"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir["lib/**/*", "CHANGELOG.md", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]
  spec.test_files = [
    "test/name_formatter_test.rb"
  ]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "faker", "~> 3.4"
end
