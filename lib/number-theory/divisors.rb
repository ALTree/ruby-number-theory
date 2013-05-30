require_relative 'utils'
require_relative 'primes'

module NumberTheory

  module Divisors

    ##
    # Returns the greatest integer k such that
    # d^k divides n.
    #
    # == Example
    #  >> Divisors.multiplicity(1000,5)
    #  => 3
    #
    def self.multiplicity(n, d)
      return 0 if n % d != 0
      m, res = n, 0
      while m % d == 0
        m /= d
        res += 1
      end
      res
    end

    ##
    # Returns the ordered list of the divisors of n (1 and n included).
    #
    # == Example
    #  >> Divisors.divisors(100)
    #  => [1, 2, 4, 5, 10, 20, 25, 50, 100]
    #
    def self.divisors(n)
      factors = Primes.factor(n)
      ps = factors.keys.sort!
      self._divisors(0, factors, ps).sort!.uniq
    end

    ## Helper function for divisors
    def self._divisors(n = 0, factors, ps) # :nodoc:
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
      give
    end

    ##
    # Return sigma_0(n), i.e. the number of divisors of n.
    #
    # == Example
    #  >> Divisors.divcount(100)
    #  => 9
    #
    def self.divcount(n)
      return nil if n < 0
      return 1 if n == 1
      divcount = 1
      Primes.factor(n).values.each {|n| divcount *= (n+1)}
      divcount
    end

    ##
    # Returns sigma_k(n), i.e. the sum of the k-th powers of 
    # the divisors of n.
    #
    # == Example
    #  >> Divisors.divisor_sigma(10, 2)
    #  => 130
    #
    def self.divisor_sigma(n, k)
      return self.divcount(n) if k == 0
      res = 0
      for i in self.divisors(n)
        res += i**k
      end
      res
    end

    ##
    # Returns true if n is a perfect number, false otherwise.
    #
    # == Example
    #  >> Divisors.perfect?(6)
    #  => true
    #
    def self.perfect? (n)
      self.divisor_sigma(n, 1) == 2*n
    end


    ##
    # Returns the valuer of phi(n), the Euler phi function; i.e.
    # the number of integers in [1..n] comprime to n. 
    #
    # == Example
    #  >> Divisors.euler_phi(30)
    #  => 8
    #
    #  >> Divisors.euler_phi(37)
    #  => 36
    #
    # == Algorithm
    # n is first factored, then the result is computed as
    # n * prod_{p} (1 - 1/p)
    # where the product spans over all the prime factors of n
    #
    def self.euler_phi(n)
      return 0 if n < 1
      res = n
      Primes.factor(n).keys.each do |i|
        res *= i - 1
        res /= i
      end
      res
    end 

 ##
    # Returns true if a positive integer is square free;
    # returns false otherwise
    #
    # A positive integer 'n' is said to be square free
    # if no prime factor appears more than once
    # in the list of prime factors for 'n'
    #
    # == Example
    #  >> Primes.square_free?(10)
    #  => true
    #
    # The integer 1 is a special case since it is 
    # both a prefect square, and square free.
    # 
    def self.square_free?(n)
      return false if n <= 0
      (Primes.factor(n)).each_value { |value| return false if value >= 2 }
      true
    end
    
  end

end
