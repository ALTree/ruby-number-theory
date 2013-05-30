module NumberTheory

  module Primes

    ## 
    # Returns true if n is (probably) prime, false otherwise.
    # For n < 10^15 the answer is accurate; greater n values
    # reported as primes have a (very) small probability of
    # actually being pseudoprimes.
    #
    # == Example
    #  >> Primes.prime?(12)
    #  => false
    #
    #  >> Primes.prime?(1882341361)
    #  => true
    #
    # == Algorithm
    # For n < 10^9 the function just test by trial division;
    # for greater n values it performs a Miller-Rabin a
    # pseudoprime test. 
    #
    # If n < 341550071728321 the test is deterministic, otherwise
    # there's a probability smaller than 7 x 10^-31 that a composite
    # number is reported as prime.
    #
    def self.prime?(n)
      if n < 10**9 or n % 2 == 0
        self._trial_division(n)
      else
        self._miller_rabin(n)
      end
    end

    ## helper method for prime?
    def self._trial_division(n) 
      return false if n < 2 or n == 4
      return true if n == 2 or n == 3 or n == 5

      mods30 = [1, 7, 11, 13, 17, 19, 23, 29] 
      return false if not mods30.include?(n % 30)

      3.step(n**0.5, 2) { |x| return false if n % x == 0 }
      true
    end

    ## helper method for prime?
    def self._miller_rabin(n, runs = 50) # :nodoc:
      if n < 341550071728321
        for a in [2, 3, 5, 7, 11, 13, 17] do
          return false if self._witness(a, n)
        end
        true
      else
        runs.times do
          a = 1 + Random.rand(n)
          return false if self._witness(a, n)
        end
        true
      end
    end

    ## helper method for _miller_rabin
    def self._witness(a, n) 
      t = Divisors.multiplicity(n - 1, 2)
      u = (n - 1) / (2**t)
      x1 = Utils.mod_exp(a, u, n)
      t.times do |i|
        x0 = x1
        x1 = (x0 * x0) % n
        return true if x1 == 1 and x0 != 1 and x0 != n-1
      end
      return true if x1 != 1
      false
    end
      
    ##
    # Memoized list of primes.
    #
    # primes_list returns a list of the prime numbers
    # between low and high (extremes included). 
    #
    # The computation is memoized in @primes_bit_array,
    # @upper_limit is the current highest prime in the list.
      # Later requests are serverd either by using the memoized
      # list, or extending it (if high > @upper_limit)
    # 
    # == Example
    #  >> Primes.primes_list(30)
    #  => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    #
    # == Algorithm
    # Primes are computed using a plain version of the Sieve 
    # of Eratosthenes; the method uses the bit-array structure
    # implemented in the NArray gem
    #
    @primes_bit_array = nil
    @upper_limit = 0

    def self.primes_list(low = 2, high)  
      self._initialize_bit_array(high) if not @primes_bit_array
      if high > @upper_limit
        self._extend_bit_array(high)
      end
      primes = NArray.object(high + 1).indgen!
      ret = primes[@primes_bit_array[0..high]].to_a
      return ret[ret.index{ |i| i >= low}..-1 ]
    end

    ## extend the memoized bit array up to high
    def self._extend_bit_array(high)
      arr = NArray.byte(high + 1)
      arr[0..@upper_limit] = @primes_bit_array[0..@upper_limit]
      arr[@upper_limit+1..-1] = NArray.byte(high - @upper_limit).fill(1)[0..-1]
      sq = (high**0.5).ceil
      2.upto(sq) do |i|
        if arr[i] == 1
          j = i*i
          j += i while j < @upper_limit
          while j <= high
            arr[j] = 0
            j += i
          end
        end
      end
      @primes_bit_array = arr
      @upper_limit = high
    end

    ## for the first computation of the bit array
    def self._initialize_bit_array  (high)
      arr = NArray.byte(high + 1).fill(1)
      arr[0], arr[1] = 0, 0
      sq = (high**0.5).ceil
      2.upto(sq) do |i|
        if arr[i] == 1
          j = i**2
          while j <= high
            arr[j] = 0
            j += i
          end
        end
      end
      @primes_bit_array = arr
      @upper_limit = high
    end

    ##
    # Returns the nth prime number.
    #
    # == Example
    #  >> Primes.nthprime(10**4)
    #  => 104729
    #
    # == Algorithm
    # Since it can be proved that the nth prime number is 
    # not greater than n * (log n + log log n)
    # the method returns the nth element of 
    # primes_list(n * (log n + log log n))
    #
    def self.nthprime(n)
      return [2, 3, 5, 7, 11, 13][n - 1] if n < 7
      lim = n * (Math.log(n) + Math.log(Math.log(n))).to_i
      self.primes_list(lim + 1)[n - 1]
    end

    ##
    # Returns the value of primepi(n), i.e. the number
    # of primes smaller than n
    #
    # == Example
    #  >> Primes.primepi(100000)
    #  => 9592
    #
    def self.primepi(n)
      return 0 if n < 2
      self.primes_list(n).size
    end


    ##
    # Factors n and returns an hash containing the prime
    # factors of n as keys and their respective multiplicities
    # as values. If limit is passed, no factors greater
    # than limit are searched, and some of the keys could be
    # composite.
    #
    # == Example
    #  >> Primes.factor(1690)
    #  => {2=>1, 5=>1, 13=>2}
    #
    #  >> Primes.factor(1690, 10)
    #  => {2=>1, 5=>1, 169=>1}
    #
    #  >> Primes.factor(79103835773176077140539788299)
    #  => {3267000013=>1, 4093082899=>1, 5915587277=>1}
    #
    # == Algorithm
    # The procedure first searches for small factors of n
    # in the primes list provided by the primes_list method.
    # Then, if needed, the procedure switches between Pollard's Rho method
    # and Pollard's p - 1 method until n is fully factored.
    #
    def self.factor(n, opts = {})
      defaults = { limit: nil, use_rho: true, use_pm1: true}
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
        factors, m = self._trial(n, 100000)
        return factors if m == 1
        return factors.merge({m => 1}) if self.prime?(m)

        if not (use_pm1 or use_rho)
          return factors.merge({m => 1})
        end
        
        count = 1
        while m > 1

          ## pollard rho
          if use_rho
            rounds = [10**3, 10**count].max
            div = self._pollard_rho(m, rounds)
            if div
              if self.prime?(div)
                fac = {div => 1}
              else
                fac = self.factor(div)
              end
              factors.merge!(fac) { |_, v1, v2| v1 + v2 }
              m /= div
              return factors.merge({m => 1}) if self.prime?(m)
            end
          end

          ## pollard p - 1
          if use_pm1
            bound = [10**3, 10**count].max
            div = self._pollard_pm1(m, bound)
            if div
              if self.prime?(div)
                fac = {div => 1}
              else
                fac = self.factor(div)
              end
              factors.merge!(fac) { |_, v1, v2| v1 + v2 }
              m /= div
              return factors.merge({m => 1}) if self.prime?(m)
            end
          end

          count += 1
        end
        return factors
      end
    end

    ## search for small factor of n (upto lim)
    def self._trial(n, lim) 
      factors = {}
      for p in self.primes_list(lim)
        if n % p == 0
          t = Divisors.multiplicity(n, p)
          factors[p] = t
          n /= p**t
        end
      end
      return factors, n
    end

    ## Pollard's rho method
    def self._pollard_rho(n, max_rounds, retries = 5) 
      v, a, i = 2, -1, 0
      retries.times do
        u, f = v, ->(x) { (x*x + a) % n }
        max_rounds.times do
          u, v = f.call(u), f.call(f.call(v))
          g = n.gcd(u - v)
          next if g == 1
          break if g == n
          return g
        end
        v, a = rand(n - 1), 1 + rand(n - 4) 
      end
      return nil
    end

    ## Pollard's p - 1 method
    def self._pollard_pm1 (n, bound, max_rounds = 8)
      primes = self.primes_list(bound)
      max_rounds.times do
        c = 2
        primes.each do |p|
          Math.log(bound, p).floor.times { c = Utils.mod_exp(c, p, n) }
        end
        g = n.gcd(c-1)
        return g if g != 1 and g != n
      end
      return nil
    end

    ##
    # Returns the smallest prime number greater than n.
    #
    # == Example
    #  >> Primes.nextprime(1000)
    #  => 1009
    #
    # == Algorithm
    # Starting from n, tests primality for each successive number
    # equals to 1 or 5 (mod 6). Return the first prime
    # found.
    #
    def self.nextprime(n)
      if n < 10007
        return self.primes_list(10007).find { |x| x > n }
      else
        p = n + 1
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
    #  >> Primes.prevprime(1000)
    #  => 997
    #
    # == Algorithm
    # Starting from n, tests primality for each previous number
    # equals to 1 or 5 (mod 6). Return the first prime
    # found.
    def self.prevprime(n)
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
    # Returns a random prime between low and high;
    # and nil if there's not one.
    #
    # == Example
    #  >> Primes.randprime(1000)
    #  => 631
    #
    #  >> Primes.randprime(10000, 20000)
    #  => 15569
    #
    def self.randprime(low = 1, high)
      p = self.nextprime(low + rand(high - low + 1))
      p = self.prevprime(p) if p > high
      return nil if p < low
      return p
    end

    ##
    # Returns the primorial of n, i.e. the product
    # of the first n prime numbers.
    #
    # == Example
    #  >> Primes.primorial(10)
    #  => 6469693230
    #
    def self.primorial(n)
      return nil if n < 0
      return [2, 6, 30, 210, 2310][n - 1] if n < 7
      upp = n * (Math.log(n) + Math.log(Math.log(n)))
      primes = self.primes_list(upp)[0..n-1]
      primes.inject {|a, b| a * b}
    end

  end

end
