require 'test/unit'
require_relative '../utils'
require_relative  '../primes'

class TestUtils < Test::Unit::TestCase

	def test_mod_exp
		assert_equal(Utils::Math::mod_exp(4, 13, 497), 445)
		assert_equal(Utils::Math::mod_exp(1777, 1885, 100000001), 2452785)
		assert_equal(Utils::Math::mod_exp(54321, 98765, 2147483647), 252276857)
	end

	def test_high_pow_divisor
		assert_equal(Utils::Math::high_pow_divisor(18, 2), 1)
		assert_equal(Utils::Math::high_pow_divisor(34992, 3), 7)
		assert_equal(Utils::Math::high_pow_divisor(34992, 3), 7)
		assert_equal(Utils::Math::high_pow_divisor(8152454278732958496, 19), 11)
	end

end


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

	def test_is_prime
		assert(!Primes::is_prime(1))
		assert(Primes::is_prime(2))
		assert(!Primes::is_prime(24680))
		assert(Primes::is_prime(982451653))
		assert(Primes::is_prime(1882341361))
		assert(Primes::is_prime(9007199254740881))
		assert(Primes::is_prime(66405897020462343733))
		assert(Primes::is_prime(416064700201658306196320137931))
		assert(Primes::is_prime(6847944682037444681162770672798288913849))
		assert(Primes::is_prime(95647806479275528135733781266203904794419563064407))
		assert(Primes::is_prime(669483106578092405936560831017556154622901950048903016651289))
		assert(Primes::is_prime(2367495770217142995264827948666809233066409497699870112003149352380375124855230068487109373226251983))
	end


end