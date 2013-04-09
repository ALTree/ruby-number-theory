require_relative 'utils'
require_relative 'divisors'

module Primes

	##
	# Returns true if +n+ is (probably) prime, false otherwise.
	# For +n+ < 10^15 the answer is accurate; greater n values
	# reported as primes have a (very) small probability of
	# actually being pseudoprimes.
	#
	# == Example
	#  >> Primes::prime?(12)
	#  => false
	#
	#  >> Primes::prime?(1882341361)
	#  => true
	#
	# == Algorithm
	# For +n+ < 10^9 the function just test +n+ by trial division;
	# for greater n values it performs a Miller-Rabin a
	# pseudoprime test. 
	#
	# If +n+ < 341550071728321 the test is deterministic, otherwise
	# there's a probability smaller than 7 x 10^-31 that a composite
	# number is reported as prime.
	#
	def self.prime? (n)
		if n < 10**9 or n % 2 == 0
			return self._trial_division(n)
		else
			return self._miller_rabin(n)
		end
	end

	def self._trial_division (n) # :nodoc:
		return false if n < 2 or n == 4
		return true if n == 2 or n == 3 or n == 5

		mods30 = [1, 7, 11, 13, 17, 19, 23, 29] 
		return false if not mods30.include?(n % 30)

		i = 3
		while i <= n**0.5
			return false if n % i == 0
			i += 2
		end
		return true
	end

	def self._witness (a, n) # :nodoc:
		t = Divisors::multiplicity(n-1, 2)
		u = (n-1)/(2**t)
		x1 = Utils::Math::mod_exp(a, u, n)
		t.times do |i|
			x0 = x1
			x1 = (x0 * x0) % n
			if x1 == 1 and x0 != 1 and x0 != n-1
				return true
			end
		end
		return true if x1 != 1
		return false
	end
	  
	def self._miller_rabin (n, runs = 50) # :nodoc:
		if n < 341550071728321
			for a in [2, 3, 5, 7, 11, 13, 17] do
				return false if self._witness(a, n)
			end
			return true
		else
			runs.times do
				a = 1 + Random.rand(n)
				return false if self._witness(a, n)
			end
			return true
		end
	end


	##
	# Class containing a list of all prime numbers up to a 
	# certain limit. All the methods that require such a list
	# for a computation query the class using its accessors methods.
	# The list is dynamically extended when needed.
	#
	class Sieve

		@primes = [2,3,5,7,11]
		@limit = 11


		##
		# Returns a list with all the prime numbers between
		# +low+ and +high+.
		#
		# == Example
		#
		#  >> Primes::Sieve.primes_list(20)
		#  => [2, 3, 5, 7, 11, 13, 17, 19]
		#
		#  >> Primes::Sieve.primes_list(1000, 1020)
		#  => [1009, 1013, 1019]
		#
		def self.primes_list (low = 1, high)
			low = low.to_i
			high = high.to_i
			if high > @limit
				Sieve.extend(high)
				@limit = high
			end
			l = @primes.index {|n| n >= low}
			h = @primes.rindex {|n| n <= high}
			return @primes[l..h]
		end

		##
		# Returns the +n+-th prime number.
		#
		# == Example
		#  >> Primes::Sieve.nthprime(5)
		#  => 11
		#
		#  >> Primes::Sieve.nthprime(500)
		#  => 3571
		#
		def self.nthprime (n)
			if @primes[n] == nil
				high = n*(Math.log(n) + Math.log(Math.log(n))).to_i
				Sieve.extend(high)
				@limit = high
			end
			return @primes[n-1]
		end

		##
		# Returns the current upper limit on the primes list.
		#
		def self.get_limit
			return @limit
		end

		##
		# Extends the primes list to contain all the prime numbers up to
		# +high+
		#
		def self.extend (high)
			# @primes = @primes + Primes::primerange(@limit + 1, high)
			@primes = @primes + Primes::_sieveprimes(@limit + 1, high)
		end

	end


	def self._sieveprimes (low, high) # :nodoc:
		sqrt = (high**0.5).ceil
		primes_up_sqrt = []
		
		if Sieve.get_limit <= sqrt
			arr = Array.new(sqrt + 1, true)
			arr[0] = false; arr[1] = false
			i = 2
			while i <= sqrt do 
				if arr[i]
					j = i*i
					while j <= high
						arr[j] = false
						j += i
					end
				end
				i += 1
			end
			
			i = 0
			while i < arr.length do
				primes_up_sqrt << i if arr[i]
				i += 1
			end

			start = primes_up_sqrt.index {|n| n > low}
			primes = primes_up_sqrt[start..-1]
		else
			primes_up_sqrt = Sieve.primes_list(sqrt)
			primes = []
		end

		arr = Array.new(high - low + 1, true)

		for p in primes_up_sqrt
			j = p - (low-1) % p - 1
			while j <= high
				arr[j] = false
				j += p
			end
		end
		
		i = 0
		while i < arr.length do
			primes << i + low if arr[i]
			i += 1
		end
		
		return primes
	end

	# def self._primerange (low = 1, high)
	# 	return [] if low > high

	# 	if low < high**0.5
	# 		res = self._full_sieve(high)
	# 		return res[res.find_index {|n| n >= low} .. -1]
	# 	else
	# 		return self._segmented_sieve(low, high)
	# 	end
	# end

	# def self._full_sieve (high)
	# 	arr = Array.new(high + 1, true)
	# 	arr[0] = false
	# 	arr[1] = false
	# 	2.upto(high ** 0.5) do |i|
	# 		if arr[i]
	# 			j = i*i
	# 			while j <= high
	# 				arr[j] = false
	# 				j += i
	# 			end
	# 		end
	# 	end
	# 	primes = []
	# 	arr.each_with_index {|b,i| primes << i if b}
	# 	return primes
	# end

	# def self._segmented_sieve(low, high)
	# 	arr = Array.new(high - low + 1, true)
	# 	primes = Primes::_primerange((high**0.5))
	# 	for p in primes
	# 		j = p - (low-1) % p - 1
	# 		while j <= high
	# 			arr[j] = false
	# 			j += p
	# 		end
	# 	end
	# 	primes = []
	# 	arr.each_with_index {|b,i| primes << i+low if b}
	# 	return primes
	# end


	##
	# Returns the value of primepi(+n+), i.e. the number
	# of primes smaller than +n+
	#
	# == Example
	#
	#  >> Primes::primepi(100000)
	#  => 9592
	#
	def self.primepi(n)
		return 0 if n < 2
		return Primes::Sieve.primes_list(n).size
	end


	##
	# Factors +n+ and returns an hash containing the prime
	# factors of +n+ as keys and their respective multiplicities
	# as values. If +limit+ is passed, no factors greater
	# than +limit+ are searched, and some of the keys could be
	# composite.
	#
	# == Example
	#
	#  >> Primes::factor(1690)
	#  => {2=>1, 5=>1, 13=>2}
	#
	#  >> Primes::factor(1690, 10)
	#  => {2=>1, 5=>1, 169=>1}
	#
	#  >> Primes::factor(79103835773176077140539788299)
	#  => {3267000013=>1, 4093082899=>1, 5915587277=>1}
	#
	# == Algorithm
	#
	# The procedure first searches for small factors of +n+
	# in the primes list provided by the +Sieve+ class 
	# Then, if needed, the procedure switches to Pollard's Rho method
	# and searches for other factors until +n+ is fully factorized.
	#
	def self.factor(n, opts = {})
		defaults = {:limit => nil, :use_rho => true, :use_pm1 => true}
		options = defaults.merge!(opts)

		limit = options[:limit]
		use_rho = options[:use_rho]
		use_pm1 = options[:use_pm1]

		return nil if n < 1
		return {1 => 1} if n == 1
		return {n => 1} if self.prime?(n)

		if limit 
			factors, m = self._trial(n, limit)
			return factors if m == 1
			return factors.merge({m => 1})
		else
			factors, m = self._trial(n, 4096)
			return factors if m == 1
			return factors.merge({m => 1}) if self.prime?(m)

			if not (use_pm1 or use_rho)
				return factors.merge({m => 1})
			end
			
			count = 1
			while m > 1

				## pollard rho
				if use_rho
					retries = count * 2
					rounds = [10**4, 10**count].max
					div = self._pollard_rho(m, retries, rounds)
					if div
						if self.prime?(div)
							fac = {div => 1}
						else
							fac = self.factor(div)
						end
						factors.merge!(fac) {|k,v1,v2| v1 + v2}
						m /= div
						return factors.merge({m => 1}) if self.prime?(m)
					end
				end

				## pollard p - 1
				if use_pm1
					bound = [10**4, 10**count].max
					max_rounds = [6, count*2].max
					div = self._pollard_pm1(m, bound, max_rounds)
					if div
						if self.prime?(div)
							fac = {div => 1}
						else
							fac = self.factor(div)
						end
						factors.merge!(fac) {|k,v1,v2| v1 + v2}
						m /= div
						return factors.merge({m => 1}) if self.prime?(m)
					end
				end

				count += 1
			end
			return factors
		end
	end

	def self._trial(n, lim) # :nodoc:
		factors = {}
		primes = Primes::Sieve.primes_list(lim)
		for p in primes
			if n % p == 0
				t = Divisors::multiplicity(n, p)
				factors[p] = t
				n /= p**t
			end
		end
		return factors, n
	end

	def self._pollard_rho (n, retries = 5, max_rounds = 10**5) # :nodoc:
		v = 2
		a = -1
		i = 0
		while i < retries do
			u = v
			f = lambda {|x| (x*x + a) % n}
			j = 0
			while j < max_rounds
				j += 1
				u = f.call(u)
				v = f.call(f.call(v))
				g = n.gcd(u - v)
				next if g == 1
				break if g == n
				return g
			end
			v = rand(n-1)
			a = 1 + rand(n-4) 
			i += 1
		end
		return nil
	end


	def self._pollard_pm1 (n, bound = 10**4, max_rounds = 8)
		primes = Primes::Sieve.primes_list(bound)
		m = 1
		primes.each {|p| m *= p ** Math.log(bound, p).floor}
		a = 2
		a.upto(max_rounds) do |a|
			x = Utils::Math::mod_exp(a, m, n) - 1
			g = n.gcd(x)
			return g if g != 1 and g != n
		end
		return nil
	end

	##
	# Returns the smallest prime number greater than +n+.
	#
	# == Example
	#  >> Primes::nextprime(1000)
	#  => 1009
	#
	def self.nextprime (n)
		if n < 10007
			return Primes::Sieve.primes_list(10007).find {|x| x > n}
		else
			p = n+1
			p += 1 while p % 6 != 1 and p % 6 != 5
			flip = (p % 6 == 1 ? 4 : 2)
			while not self.prime?(p)
				p += flip
				flip = 6 - flip 
			end
			return p
		end
	end

	##
	# Returns the greatest prime number smaller than +n+.
	#
	# == Example
	#  >> Primes::prevprime(1000)
	#  => 997
	#
	def self.prevprime (n)
		return nil if n < 3
		p = n-1
		p -= 1 while p % 6 != 1 and p % 6 != 5
		flip = (p % 6 == 1 ? 2 : 4)
		while not self.prime?(p)
			p -= flip
			flip = 6 - flip 
		end
		return p
	end

	##
	# Returns a random prime between +low+ and +high+;
	# and +nil+ if there's not one.
	#
	# == Example
	#
	#  >> Primes::randprime(1000)
	#  => 631
	#
	#  >> Primes::randprime(10000, 20000)
	#  => 15569
	#
	def self.randprime(low = 1, high)
		p = self.nextprime(low + rand(high+1))
		p = self.prevprime(p) if p > high
		return nil if p < low
		return p
	end

	##
	# Return the primorial of +n+, i.e. the product
	# of the first +n+ prime numbers.
	#
	# == Example
	#
	#  >> Primes::primorial(10)
	#  => 6469693230
	#
	def self.primorial(n)
		return nil if n < 0
		return [2,6,30,210,2310][n-1] if n < 7

		upp = n * (Math.log(n) + Math.log(Math.log(n)))
		primes = Sieve.primes_list(upp)[0..n-1]
		return primes.inject {|a,b| a*b}
	end

	Sieve.primes_list(1000)

end

