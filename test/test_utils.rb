require 'test/unit'
require_relative '../lib/utils'

class TestUtils < Test::Unit::TestCase

	def test_mod_exp
		assert_equal(Utils::Math::mod_exp(4, 13, 497), 445)
		assert_equal(Utils::Math::mod_exp(1777, 1885, 100000001), 2452785)
		assert_equal(Utils::Math::mod_exp(54321, 98765, 2147483647), 252276857)
	end


end