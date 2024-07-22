require "minitest/autorun"
require "gaelic_name_formatter"

class GaelicNameFormatterTest < Minitest::Test
  def setup
    @formatter = GaelicNameFormatter.new("Trevor McDonald")
  end

  def test_non_gaelic_names?
    names = File.read("./test/files/non-galic_names.txt").split("\n")
    names.each do |name|
      @formatter.name = name
      refute @formatter.gaelic?, "Expected '#{name}' to not be gaelic"
    end
  end

  def test_gaelic_names?
    names = File.read("./test/files/galic_family_names.txt").split("\n")
    names.each do |name|
      @formatter.name = name.upcase
      assert @formatter.gaelic?, "Expected '#{name}' to be gaelic"
      @formatter.name = name.downcase
      assert @formatter.gaelic?, "Expected '#{name}' to be gaelic"
    end
  end

  def test_format
    names = File.read("./test/files/galic_family_names.txt").split("\n")
    names.each do |name|
      @formatter.name = name.upcase
      assert_equal name, @formatter.format, "Expected '#{name}' to be formatted as '#{name}'"
    end
  end

  def test_formatted
    assert_formatted("McClure", "MCCLURE")
    assert_formatted("McLaughlin", "MCLAUGHLIN")
    assert_formatted("McDermott", "MCDERMOTT")
  end

  private

  def assert_formatted(expected, input)
    @formatter.name = input
    assert_equal expected, @formatter.format
  end

  def assert_parsed(input, expected)
    result = @formatter.parse_formatted(input)
    expected.each do |key, value|
      assert_equal value, result[key], "Mismatch in #{key} for '#{input}'"
    end
    ([:prefix, :first_name, :last_name, :suffix] - expected.keys).each do |key|
      assert_nil result[key], "Expected nil for #{key} in '#{input}'"
    end
  end
end
