require "minitest/autorun"
require "faker"
require_relative "name_formatter"

class NameFormatterTest < Minitest::Test
  def setup
    @formatter = NameFormatter.new
  end

  def test_simple_names
    assert_formatted "Mr. James Carter", "Mr. James Carter".upcase
    assert_formatted "Kyle Welsby", "Kyle Welsby".upcase
  end

  def test_names_with_suffixes
    assert_parsed "Alyson McLaughlin Esq.",
      first_name: "Alyson", last_name: "McLaughlin", suffix: "Esq."
    assert_parsed "Jonna McLaughlin Jr.",
      first_name: "Jonna", last_name: "McLaughlin", suffix: "Jr."
    assert_parsed "Jonna McLaughlin PHD".upcase,
      first_name: "Jonna", last_name: "McLaughlin", suffix: "PhD"
  end

  def test_names_with_prefixes
    assert_parsed "The Hon. Jonna McLaughlin",
      prefix: "The Hon.", first_name: "Jonna", last_name: "McLaughlin"
    assert_parsed "Dr. JD Wong",
      prefix: "Dr.", first_name: "Jd", last_name: "Wong"
  end

  def test_compound_last_names
    assert_parsed "Dave Rodriguez-McDermott".upcase,
      first_name: "Dave", last_name: "Rodriguez-McDermott"
  end

  def test_multi_part_last_names
    assert_parsed "ALLAN MAIA DA SILVA SANTOS",
      first_name: "Allan", last_name: "Maia da Silva Santos"
    assert_parsed "James Van Der Beek",
      first_name: "James", last_name: "van der Beek"
    assert_parsed "SAM VAN CAELENBERGH",
      first_name: "Sam", last_name: "Van Caelenbergh"
    assert_parsed "Karl-Theodor zu Guttenberg",
      first_name: "Karl-Theodor", last_name: "zu Guttenberg"
  end

  def test_names_with_apostrophes
    assert_parsed "Giovanni Dell'Aquila",
      first_name: "Giovanni", last_name: "Dell'Aquila"
  end

  def test_names_with_particles
    assert_parsed "Pier della Francesca",
      first_name: "Pier", last_name: "della Francesca"
    assert_parsed "Andrea del Verrocchio",
      first_name: "Andrea", last_name: "del Verrocchio"
    assert_parsed "José Ortega y Gasset",
      first_name: "José", last_name: "Ortega y Gasset"
  end

  def test_spanish_names
    assert_parsed "Camilo José Cela",
      first_name: "Camilo", last_name: "José Cela"
    assert_parsed "Maria del Carmen Martinez",
      first_name: "Maria", last_name: "del Carmen Martinez"
    assert_parsed "José Martínez",
      first_name: "José", last_name: "Martínez"
  end

  def test_unicode_names
    assert_parsed "Ｔａｒｏ Yamada",
      first_name: "Ｔａｒｏ", last_name: "Yamada"
    assert_parsed "Ægir Björnsson",
      first_name: "Ægir", last_name: "Björnsson"
    assert_parsed "Νικόλαος Παπαδόπουλος",
      first_name: "Νικόλαος", last_name: "Παπαδόπουλος"
    assert_parsed "ΘΕΟΔΩΡΟΣ ΚΟΛΟΚΟΤΡΩΝΗΣ",
      first_name: "Θεοδωροσ", last_name: "Κολοκοτρωνησ"
  end

  def test_german_names
    assert_parsed "Hans-Peter Fischer",
      first_name: "Hans-Peter", last_name: "Fischer"
    assert_parsed "HANS GROß",
      first_name: "Hans", last_name: "Groß"
  end

  def test_company_names
    assert_formatted "Kovacek LLC", "Kovacek LLC".upcase
    assert_formatted "Fedel Inc", "Fedel Inc".upcase
    assert_formatted "Fedel GmbH.", "Fedel GMBH.".upcase
    assert_formatted "McDermott-Stanton", "MCDERMOTT-STANTON"
    assert_formatted "DeBuque, Upton and Hassel", "DeBuque, Upton and Hassel".upcase
    assert_formatted "McKenzie, Gislason and Haag", "McKenzie, Gislason and Haag".upcase
    assert_formatted "McKenzie-D'Amore", "McKenzie-D'Amore".upcase
    assert_formatted "Lubowitz-MacGyver", "Lubowitz-MacGyver".upcase
  end

  def test_de_names
    de_names = %w[DeBerry DeBlasio DeBolt DeBord DeBose DeBusk DeForest DeGroot DeHaven DeJong DeLong DeMar DeMille DeNiro DePalma DeVito DeVries DeWitt]
    de_names.each do |name|
      assert_formatted "Robert #{name}", "Robert #{name}".upcase
    end

    assert_formatted "Debra Smith", "DEBRA SMITH"
    assert_formatted "Deon Smith", "DEON SMITH"
    assert_formatted "Demetrius Smith", "Demetrius SMITH".upcase
    assert_formatted "Dewey Smith", "DEWEY SMITH"
  end

  def test_edge_cases
    assert_formatted "Denesik-Vandervort", "Denesik-Vandervort".upcase
  end

  def test_stress
    skip "Long running test"
    100_000.times do
      name = Faker::Name.name
      assert_formatted name, name
    end
  end

  def test_company_stress
    skip "Long running test"
    100_000.times do
      name = Faker::Company.name
      assert_formatted name, name
    end
  end

  private

  def assert_formatted(expected, input)
    assert_equal expected, @formatter.format(input)
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
