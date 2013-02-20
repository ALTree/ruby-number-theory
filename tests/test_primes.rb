require 'test/unit'
require_relative  '../primes'

class TestPrimes < Test::Unit::TestCase

	def test_trial_division
		assert(!Primes::trial_division(1))
		assert(Primes::trial_division(2))
		assert(!Primes::trial_division(24680))
		assert(Primes::trial_division(982451653))
		assert(Primes::trial_division(1882341361))
	end

	def test_miller_rabin
		assert(!Primes::trial_division(24680))
		assert(Primes::miller_rabin(982451653))
		assert(Primes::miller_rabin(1882341361))
		assert(Primes::miller_rabin(9007199254740881))
		assert(Primes::miller_rabin(9007199254740881))
	end

	def test_prime?
		assert(!Primes::prime?(1))
		assert(Primes::prime?(2))
		assert(!Primes::prime?(24680))
		assert(Primes::prime?(982451653))
		assert(Primes::prime?(1882341361))
		assert(Primes::prime?(9007199254740881))
		assert(Primes::prime?(66405897020462343733))
		assert(Primes::prime?(416064700201658306196320137931))
		assert(Primes::prime?(6847944682037444681162770672798288913849))
		assert(Primes::prime?(95647806479275528135733781266203904794419563064407))
		assert(Primes::prime?(669483106578092405936560831017556154622901950048903016651289))
		assert(Primes::prime?(2367495770217142995264827948666809233066409497699870112003149352380375124855230068487109373226251983))
	end

	def test_primerange
		assert_equal(Primes::primerange(10), [2, 3, 5, 7])
		assert_equal(Primes::primerange(10, 30), [11, 13, 17, 19, 23, 29])
		assert_equal(Primes::primerange(1000,10000).size, 1229 - 168)
		assert_equal(Primes::primerange(100000).size, 9592)
	end

	def test_primepi
		assert_equal(Primes::primepi(10), 4)
		assert_equal(Primes::primepi(10**3), 168)
		assert_equal(Primes::primepi(10**6), 78498)
	end

end
