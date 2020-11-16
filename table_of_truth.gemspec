
Gem::Specification.new do |gem|
  gem.name = 'table_of_truth'
  gem.version = '0.1.1'
  gem.summary = 'A gem for comparing boolean expressions'
  gem.homepage = 'https://github.com/broothie/table_of_truth#readme'
  gem.license = 'MIT'

  gem.author = 'Andrew Booth'
  gem.email = 'andrew@andrewbooth.xyz'

  gem.files = Dir.glob('lib/**/*.rb')
  gem.add_runtime_dependency "colorize", "~> 0.8.1"

  gem.add_development_dependency "pry", "~> 0.13.1"
  gem.add_development_dependency "rake", "~> 13.0"
  gem.add_development_dependency "spud", "~> 0.1.18"
end
