require_relative 'utils'
require_relative 'primes'

module Divisors

	def self.multiplicity (n, d)
		return 0 if n % d != 0
		m = n
		res = 0
		while m % d == 0
			m /= d
			res += 1
		end
		return res
	end


	def self.divisors (n)
		factors = Primes::factor(n)
		ps = factors.keys.sort!
		return self._divisors(0, factors, ps).sort!.uniq
	end

	def self._divisors (n = 0, factors, ps)
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


	def self.divcount (n)
		return nil if n < 0
		return 1 if n == 1
		divcount = 1
		Primes::factor(n).values.each {|n| divcount *= (n+1)}
		return divcount
	end


	def self.divisor_sigma (n, k)
		return self.divcount(n) if k == 0
		res = 0
		for i in self.divisors(n)
			res += i**k
		end
		return res
	end

	def self.perfect? (n)
		return self.divisor_sigma(n, 1) == 2*n
	end

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


