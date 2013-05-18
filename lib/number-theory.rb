module NumberTheory

	begin
		require 'narray'
	rescue LoadError
		raise LoadError, "You must have NArray installed"
	end

	# Load modules
	require File.dirname(__FILE__) + '/number-theory/primes.rb'
	require File.dirname(__FILE__) + '/number-theory/divisors.rb'
	require File.dirname(__FILE__) + '/number-theory/utils.rb'

end