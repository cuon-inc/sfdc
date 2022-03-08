require_relative "lib/sfdc/version"

Gem::Specification.new do |spec|
  spec.name          = "sfdc"
  spec.version       = Sfdc::VERSION
  spec.authors       = ["Shiohara Kazutaka"]
  spec.email         = ["shiohara.kazutaka@keiken.co.jp"]

  spec.summary       = "Client for Salesforce REST api"
  spec.description   = "Client for Salesforce REST api"
  spec.homepage      = "https://github.com/cuon-inc/sfdc"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cuon-inc/sfdc"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 7.0.1"
  spec.add_dependency "restforce", "~> 5.2.0"
end
