require_relative 'utils'
module
 Primes

	def self.prime? (n)
		unless n.class.superclass == Integer
			raise ArgumentError
		end

		if n < 10**9 or n % 2 == 0
			return self.trial_division(n)
		else
			return self.miller_rabin(n)
		end
	end

	def self.trial_division (n)
		return false if n <= 1 or n == 4
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

	def self.witness (a, n)
		# set n - 1 = 2^t * u 
		t = Utils::Math::high_pow_divisor(n-1, 2)
		u = (n-1)/(2**t)
		# check if a is witness for non-primality of n
		# using fermat theorem
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
	  
	def self.miller_rabin (n, runs = 48)
		if n < 341550071728321
			for a in [2, 3, 5, 7, 11, 13, 17] do
				return false if self.witness(a, n)
			end
			return true
		else
			runs.times do
				a = 1 + Random.rand(n)
				if self.witness(a, n)
					return false
				end
			end
			return true
		end
	end

	# def self.primerange(low = 1, high)
	# 	return [] if low > high
	# 	arr = Array.new(high + 1, true)
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
	# 	start = primes.find_index {|n| n >= low}
	# 	return primes[start..-1]
	# end

	def self.primerange(low = 1, high)
		return [] if low > high

		if low < high**0.5
			res = self.full_sieve(high)
			return res[res.find_index {|n| n >= low} .. -1]
		else
			return self.segmented_sieve(low, high)
		end
	end

	def self.full_sieve(high)
		arr = Array.new(high + 1, true)
		arr[0] = false
		arr[1] = false
		2.upto(high ** 0.5) do |i|
			if arr[i]
				j = i*i
				while j <= high
					arr[j] = false
					j += i
				end
			end
		end
		primes = []
		arr.each_with_index {|b,i| primes << i if b}
		return primes
	end

	def self.segmented_sieve(low, high)
		arr = Array.new(high - low + 1, true)
		primes = Primes::primerange((high**0.5).to_i)
		for p in primes
			j = p - (low-1) % p - 1
			while j <= high
				arr[j] = false
				j += p
			end
		end
		primes = []
		arr.each_with_index {|b,i| primes << i+low if b}
		return primes
	end

	def self.primepi(n)
		if n < 2
			return 0
		else
			return Primes::primerange(n).size
		end
	end

	def self.factor(n)
		return {n=>1} if self.prime?(n)

		return self.small_factors(n, 10000)

		# TODO: pollard rho

	end

	def self.small_factors(n, lim)
		factors = {}
		primes = self.primerange(lim)
		for p in primes
			if n % p == 0
				t = Utils::Math::high_pow_divisor(n, p)
				factors[p] = t
				n /= p**t
				if self.prime?(n)
					factors[n] = 1
					return factors
				end
			end
		end
		factors[n] = 1 if n > 1
		return factors
	end

end

