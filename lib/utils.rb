
module NumberTheory # :nodoc: :all:

	def self.time_once
		start = Time.now
		yield 
		(Time.now - start).round(3)
	end

	module Utils

		def self.mod_exp (a, b, m)
			if b >= 0
				res = 1
				while b > 0
					res = (res * a) % m if b & 1 != 0
					b >>= 1
					a = (a * a) % m
				end
				return res
			else
				return self.mod_exp(self.mod_inv(a, m), -b, m)
			end
		end

		def self.mod_inv (a, m)
			return 0 if a % m == 0
			g, a, y = self._eca(a, m) 
			return g != 1 ? 0 : a % m
		end

		def self._eca (a, b)
			return b, 0, 1 if a == 0
			g, y, x = self._eca(b % a, a)
        	return g, x - y * (b / a).floor, y
		end


	end


end


