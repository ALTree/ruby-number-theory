require_relative 'utils'
require_relative 'divisors'

module Primes

	def self.prime? (n)
		if n < 10**9 or n % 2 == 0
			return self._trial_division(n)
		else
			return self._miller_rabin(n)
		end
	end

	def self._trial_division (n)
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

	def self._witness (a, n)
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
	  
	def self._miller_rabin (n, runs = 50)
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

	class Sieve

		@primes = [2,3,5,7,11]
		@limit = 11

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

		def self.nthprime (n)
			if @primes[n] == nil
				high = n*(Math.log(n) + Math.log(Math.log(n))).to_i
				Sieve.extend(high)
				@limit = high
			end
			return @primes[n-1]
		end

		def self.get_limit
			return @limit
		end

		def self.extend (high)
			# @primes = @primes + Primes::primerange(@limit + 1, high)
			@primes = @primes + Primes::_sieveprimes(@limit + 1, high)
		end

	end


	def self._sieveprimes (low, high)
		sqrt = (high**0.5).ceil
		primes_up_sqrt = []
		
		if Sieve.get_limit <= sqrt
			arr = Array.new(sqrt + 1, true)
			arr[0] = false
			arr[1] = false
			2.upto(sqrt) do |i|
				if arr[i]
					j = i*i
					while j <= high
						arr[j] = false
						j += i
					end
				end
			end
			arr.each_with_index {|b,i| primes_up_sqrt << i if b}
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

		arr.each_with_index {|b,i| primes << i+low if b}
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


	def self.primepi(n)
		return 0 if n < 2
		return Primes::Sieve.primes_list(n).size
	end


	def self.factor(n, limit = 1)
		return nil if n < 1
		return {1 => 1} if n == 1
		return {n => 1} if self.prime?(n)

		if limit > 1
			factors, m = self._small_factors(n, limit)
			return factors if m == 1
			return factors.merge({m => 1})
		else
			factors, m = self._small_factors(n, 4096)
			return factors if m == 1
			return factors.merge({m => 1}) if self.prime?(m)

			count = 1
			while m > 1
				div = self._pollard_rho(m, count * 3)
				if div
					if self.prime?(div)
						fac = {div => 1}
					else
						fac = self.factor(div)
					end
					factors.merge!(fac) {|k,v1,v2| v1+v2}
					m /= div
					return factors.merge({m => 1}) if self.prime?(m)
				end
				count += 1
			end
			return factors
		end
	end

	def self._small_factors(n, lim)
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

	def self._pollard_rho (n, retries = 5)
		v = 2
		a = -1
		retries.times do
			u = v
			f = lambda {|x| (x*x + a) % n}
			j = 0
			while true
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
		end
		return nil
	end


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


	def self.randprime(low = 1, high)
		p = self.nextprime(low + rand(high+1))
		p = self.prevprime(p) if p > high
		return nil if p < low
		return p
	end

	def self.primorial(n)
		return nil if n < 0
		return [2,6,30,210,2310][n-1] if n < 7

		upp = n * (Math.log(n) + Math.log(Math.log(n)))
		primes = Sieve.primes_list(upp)[0..n-1]
		return primes.inject {|a,b| a*b}
	end


end

