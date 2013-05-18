require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'number-theory'))

include NumberTheory

class TestDivisors < Test::Unit::TestCase

	def test_divisors
		assert_equal(Divisors::divisors(32), [1, 2, 4, 8, 16, 32])
		assert_equal(Divisors::divisors(210), [1, 2, 3, 5, 6, 7, 10, 14, 15, 21, 30, 35, 42, 70, 105, 210])
	end

	def test_divcount
		assert_equal(Divisors::divcount(210), 16)
		assert_equal(Divisors::divcount(32000), 36)
		assert_equal(Divisors::divcount(3861000), 256)
		assert_equal(Divisors::divcount(4900265546530028103000), 12288)
	end

	def test_multiplicity
		assert_equal(Divisors::multiplicity(18, 2), 1)
		assert_equal(Divisors::multiplicity(34992, 3), 7)
		assert_equal(Divisors::multiplicity(8152454278732958496, 19), 11)
	end

	def test_divisor_sigma
		assert_equal(Divisors::divisor_sigma(16,1), 31)
		assert_equal(Divisors::divisor_sigma(20,2), 546)
		assert_equal(Divisors::divisor_sigma(28,5), 17766056)
		assert_equal(Divisors::divisor_sigma(15,7), 170939688)
	end

	def test_euler_phi
		assert_equal(Divisors::euler_phi(12), 4)
		assert_equal(Divisors::euler_phi(19), 18)
		assert_equal(Divisors::euler_phi(25555), 19296)
		assert_equal(Divisors::euler_phi(87654), 25032)
	end

	def test_perfect?
		assert(Divisors::perfect?(6))
		assert(Divisors::perfect?(496))
		assert(Divisors::perfect?(2305843008139952128))
	end



end