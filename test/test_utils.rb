require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'number-theory'))


include NumberTheory

class TestUtils < Test::Unit::TestCase

	def test_mod_exp
		assert_equal(Utils::mod_exp(123, 0, 234), 1)
		assert_equal(Utils::mod_exp(4, 13, 497), 445)
		assert_equal(Utils::mod_exp(1777, 1885, 100000001), 2452785)
		assert_equal(Utils::mod_exp(54321, 98765, 2147483647), 252276857)
		assert_equal(Utils::mod_exp(4, -13, 497), 86)
		assert_equal(Utils::mod_exp(1777, -1885, 100000001), 9159955)
		assert_equal(Utils::mod_exp(54321, -98765, 2147483647), 1899303417)
	end

	def test_mod_inv
		assert_equal(Utils::mod_inv(3, 17), 6)
		assert_equal(Utils::mod_inv(116003, 1500450271), 287173581)
		assert_equal(Utils::mod_inv(5915587277, 54673257461630679457), 50186303895605983691)
	end

end