require 'test/unit'
require_relative '../lib/combinatorics'

include NumberTheory

class TestCombinatorics < Test::Unit::TestCase

	def test_binomial
		assert_equal(Combinatorics::binomial(10,3), 120)
		assert_equal(Combinatorics::binomial(30,13), 119759850)
		assert_equal(Combinatorics::binomial(50,35), 2250829575120)
	end

	def test_factorial
		assert_equal(Combinatorics::factorial(10), 3628800)
	end

	def test_partition_n
		assert_equal(Combinatorics::partition_number(10), 42)
		assert_equal(Combinatorics::partition_number(100), 190569292)
		assert_equal(Combinatorics::partition_number(1000), 24061467864032622473692149727991)
	end

end