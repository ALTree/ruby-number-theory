Gem::Specification.new do |s|
  
	s.name        = 'number-theory'
  	s.version     = '0.0.1'
  	s.summary     = "Number Theory in Ruby"
  	s.description = "A number theory library written in pure Ruby. Provides methods for primality test, factoring integers, and more."
  
 	s.author      = 'Alberto Donizetti'
  	s.email       = 'alb.donizett@gmail.com'
  
  	s.files       = Dir['lib/**/*.rb'] + Dir['test/**/*.rb'] + Dir['[A-Z]*']
  	s.platform    = Gem::Platform::RUBY
  	spec.license  = 'GNU GPL 3'

	s.require_path = "lib"
	s.test_files   = Dir['test/**/*.rb']


  	s.homepage    = 'http://rubygems.org/gems/example'
end