require 'test/unit'
require_relative '../utils'

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