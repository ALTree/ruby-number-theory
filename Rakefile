require 'rake/testtask'

namespace :test do
	desc "run all tests"
	task :run do
		Dir.glob('test/*.rb').each do |name| 	
			ruby name
		end
	end
end
