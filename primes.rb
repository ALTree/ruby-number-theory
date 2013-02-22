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
		t = Utils::Math::multiplicity(n-1, 2)
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

	def self.factor(n, limit = 1)

		return {n => 1} if self.prime?(n)

		if limit > 1
			factors, m = self.small_factors(n, limit)
			return factors if m == 1
			return factors.merge({m => 1})
		else

			factors, m = self.small_factors(n, 10000)

			return factors if m == 1
			return factors.merge({m => 1}) if self.prime?(m)

			count = 1
			while m > 1
				div = self.pollard_rho(m, count * 3)
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


	def self.small_factors(n, lim)
		factors = {}
		primes = self.primerange(lim)
		for p in primes
			if n % p == 0
				t = Utils::Math::multiplicity(n, p)
				factors[p] = t
				n /= p**t
			end
		end
		return factors, n
	end

	def self.pollard_rho (n, retries = 5)
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

	

end

