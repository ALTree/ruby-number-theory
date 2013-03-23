
module Combinatorics

	def self.binomial (n, k)
		return 0 if k < 0 or k > n
		k = n - k if k > n - k
		res = 1
		(1..k).each {|i| res *= (n - k + i)}
		(1..k).each {|i| res /= i}
		return res
	end

	def self.factorial (n)
		return (1..n).inject(:*)
	end

	def self.partition_number (n)
		arr = Array.new(n+1, 1)
		gpn = self._compute_gpn(n)
		1.upto(n) do |i|
			sign = +1
			count = 0
			res = 0
			for j in gpn
				break if i - j < 0
				if count == 2
					count = 0
					sign = -sign
				end
				res += (sign) * arr[i-j]
				count += 1
			end
			arr[i] = res
		end
		return arr[n]
	end

	def self._compute_gpn (lim)
		gpn = []
		m = 1
		m1 = 0
		until m1 > lim do
			m1 = (m * (3*m - 1)) / 2
			m2 = (-m * (3*-m - 1)) / 2
			gpn << m1 << m2
			m += 1
		end
		return gpn
	end






end