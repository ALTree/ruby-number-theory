require_relative 'utils'
require_relative 'primes'

module NumberTheory

	module Divisors

		##
		# Returns the greatest integer +k+ such that
		# <tt>d^k</tt> divides +n+.
		#
		# == Example
		#
		#  >> Divisors::multiplicity(1000,5)
		#  => 3
		#
		def self.multiplicity (n, d)
			return 0 if n % d != 0
			m, res = n, 0
			while m % d == 0
				m /= d
				res += 1
			end
			return res
		end

		##
		# Returns the ordered list of the divisors of +n+ (1 and +n+ included).
		#
		# == Example
		#
		#  >> Divisors::divisors(100)
		#  => [1, 2, 4, 5, 10, 20, 25, 50, 100]
		#
		def self.divisors (n)
			factors = Primes::factor(n)
			ps = factors.keys.sort!
			return self._divisors(0, factors, ps).sort!.uniq
		end

		##
		# Helper function for divisors()
		#
		def self._divisors (n = 0, factors, ps) # :nodoc:
			give = []
			if n == ps.size
				give << 1
			else
				pows = [1]
				factors[ps[n]].times {pows << pows[-1]*ps[n]}
				for q in self._divisors(n+1, factors, ps)
					for p in pows
						give << p * q
					end
				end
			end
			return give
		end

		##
		# Return sigma_0(+n+), i.e. the number of divisors of +n+.
		#
		# == Example
		#
		#  >> Divisors::divcount(100)
		#  => 9
		#
		def self.divcount (n)
			return nil if n < 0
			return 1 if n == 1
			divcount = 1
			Primes::factor(n).values.each {|n| divcount *= (n+1)}
			return divcount
		end

		##
		# Return sigma_k(+n+), i.e. the sum of the +k+-th powers of 
		# the divisors of +n+.
		#
		# == Example
		#
		#  >> Divisors::divisor_sigma(10, 2)
		#  => 130
		#
		def self.divisor_sigma (n, k)
			return self.divcount(n) if k == 0
			res = 0
			for i in self.divisors(n)
				res += i**k
			end
			return res
		end

		##
		# Returns true if +n+ is a perfect number, false otherwise.
		#
		# == Example
		#
		#  >> Divisors::perfect?(6)
		#  => true
		#
		def self.perfect? (n)
			return self.divisor_sigma(n, 1) == 2*n
		end


		##
		# Returns the valuer of phi(+n+), the Euler phi function; i.e.
		# the number of integers in [1..n] comprime to +n+. 
		#
		# == Example
		#
		#  >> Divisors::euler_phi(30)
		#  => 8
		#
		#  >> Divisors::euler_phi(37)
		#  => 36
		#
		# == Algorithm
		#
		# +n+ is first factored, then the result is computed as
		# <tt> n * prod_{p} (1 - 1/p) </tt>
		# where the product spans over all the prime factors of +n+
		#
		def self.euler_phi (n)
			return 0 if n < 1
			res = n
			Primes::factor(n).keys.each do |i|
				res *= i - 1
				res /= i
			end
			return res
		end	


	end

end