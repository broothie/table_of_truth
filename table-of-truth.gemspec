
Gem::Specification.new do |gem|
  gem.name = 'table-of-truth'
  gem.version = '0.1.0'
  gem.summary = 'A gem for comparing boolean expressions'
  gem.homepage = 'https://github.com/broothie/ruby-truth-table#readme'
  gem.license = 'MIT'

  gem.author = 'Andrew Booth'
  gem.email = 'andrew@andrewbooth.xyz'

  gem.files = Dir.glob('lib/*.rb')
  gem.add_runtime_dependency 'colorize', '~> 0.8.1'
end
