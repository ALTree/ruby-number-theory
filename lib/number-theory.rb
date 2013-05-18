module NumberTheory

	begin
		require 'narray'
	rescue LoadError
		raise LoadError, "You must have NArray installed"
	end

	# Load modules
	require File.dirname(__FILE__) + '/lib/primes.rb'
	require File.dirname(__FILE__) + '/lib/divisors.rb'
	require File.dirname(__FILE__) + '/lib/utils.rb'

end