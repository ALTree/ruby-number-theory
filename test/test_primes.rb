require 'test/unit'
require_relative  '../lib/primes'

class TestPrimes < Test::Unit::TestCase

	def test__trial_division
		assert(!Primes::_trial_division(1))
		assert(Primes::_trial_division(2))
		assert(!Primes::_trial_division(24680))
		assert(Primes::_trial_division(982451653))
		assert(Primes::_trial_division(1882341361))
	end

	def test__miller_rabin
		assert(!Primes::_miller_rabin(24680))
		assert(Primes::_miller_rabin(982451653))
		assert(Primes::_miller_rabin(1882341361))
		assert(Primes::_miller_rabin(9007199254740881))
		assert(Primes::_miller_rabin(9007199254740881))
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

	def test_primes_list
		assert_equal(Primes::Sieve.primes_list(10), [2, 3, 5, 7])
		assert_equal(Primes::Sieve.primes_list(10, 30), [11, 13, 17, 19, 23, 29])
		assert_equal(Primes::Sieve.primes_list(1000,10000).size, 1229 - 168)
		assert_equal(Primes::Sieve.primes_list(100000).size, 9592)
	end

	def test_primepi
		assert_equal(Primes::primepi(10), 4)
		assert_equal(Primes::primepi(10**3), 168)
		assert_equal(Primes::primepi(10**6), 78498)
	end

	def test_factor
		assert_equal(Primes::factor(10), {2=>1, 5=>1})
		assert_equal(Primes::factor(10125000), {2=>3, 3=>4, 5=>6})
		assert_equal(Primes::factor(10125001), {10125001=>1})
		assert_equal(Primes::factor(79103835773176077140539788299), {3267000013=>1, 4093082899=>1, 5915587277=>1})
		assert_equal(Primes::factor(323424426232167763068694468589), {5915587277=>1, 54673257461630679457=>1})
	end

	def test_nextprime
		assert_equal(Primes::nextprime(5), 7)
		assert_equal(Primes::nextprime(98765432100), 98765432137)
		assert_equal(Primes::nextprime(9876543210000000000), 9876543210000000029)
	end

	def test_prevprime
		assert_equal(Primes::prevprime(1234567890), 1234567811)
		assert_equal(Primes::prevprime(1234567890000000000), 1234567889999999953)
	end

	def test_nthprimes
		assert_equal(Primes::Sieve.nthprime(10), 29)
		assert_equal(Primes::Sieve.nthprime(1000), 7919)
		assert_equal(Primes::Sieve.nthprime(10000), 104729)
	end

	def test_primorial
		assert_equal(Primes::primorial(5), 2310)
		assert_equal(Primes::primorial(17), 1922760350154212639070)
		assert_equal(Primes::primorial(25), 2305567963945518424753102147331756070)
	end



end
