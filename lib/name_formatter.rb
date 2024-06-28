require "name_formatter/version"
require "gaelic_name_formatter"

class NameFormatter
  VERSION = NameFormatterModule::VERSION
  PREFIXES = Set.new(["Mr", "Mrs", "Ms", "Miss", "The Hon", "Rev", "Dr", "Fr", "Pres", "Prof", "Msgr", "Sen", "Gov", "Rep", "Amb"]).freeze
  SUFFIXES = Set.new([
    "Esq", "Jr", "Sr", "III", "II", "I", "V", "IV", "MD", "DC", "DO", "DVM", "LLD", "VM", "DDS", "Ret", "CPA", "JD", "PhD",
    "LLC", "Inc", "Corp", "Ltd", "Co", "LLC", "PLC", "GmbH", "AG", "SA", "SARL", "SRL", "BV", "CV", "NV", "SE", "SC", "SL", "SLL", "SLLC", "SCS", "SCA", "SCRL", "SCA"
  ]).freeze

  NAME_REGEX = /^(?<prefix>(#{PREFIXES.join("|")}?)\.?)?\s*(?<first_name>[\w-]+)\s+(?<last_name>[\w\s'-]+)\s*(?<suffix>(#{SUFFIXES.join("|")})\.?)?$/ix

  COMPANY_SUFFIX_REGEX = /^(.+)\s+(Inc\.?|Corp\.?|Ltd\.?|LLC|LLP|LP|Limited|Corporation|Company)$/i
  FAMILY_BUSINESS_REGEX = /^(.+)\s+(?:and|&)\s+Sons$/i
  MULTIPLE_FAMILY_NAMES_REGEX = /^[\w']+,\s+[\w']+\s+(?:and|&)\s+[\w']+$/i
  DOUBLE_BARRELLED_NAME_REGEX = /^[\w']+-[\w']+$/
  LAW_FIRM_REGEX = /^(?:[A-Z][a-z]+\s+){2,}(?:LLP|LLC|PC|PLLC)?$/
  COMPANY_CO_REGEX = /^(.+)\s+(?:Company|Co\.)$/i
  GROUP_HOLDINGS_REGEX = /^(.+)\s+(?:Group|Holdings)$/i
  GEOGRAPHIC_COMPANY_REGEX = /^(.+)\s+of\s+[A-Z][a-z]+$/i
  TRADING_ENTERPRISES_REGEX = /^(.+)\s+(?:Trading|Enterprises)$/i

  DUNAME_REGEX = /^Du[b](?=[aeiou])/i
  DENAME_REGEX = /^De[bfghjlmnpvw][aeioulr](?!(?:sik|a)(?:[-,])?$)/i

  PARTICLE_REGEX = /^(de[rsl]|d[aiu]|v[oa]n|te[nr]|la|les|y|and|zu|dell[ao])$/i

  def parse(name, last_name_only: false)
    return parse_company_name(name) if company_name?(name)

    parts = name.strip.split(/\s+/)

    prefix = extract_prefix_or_suffix(parts, PREFIXES)
    suffix = extract_prefix_or_suffix(parts.reverse, SUFFIXES)

    if last_name_only
      first_name = nil
      last_name = parts.reject { |part| part == suffix }.join(" ")
    elsif parts.size > 1

      first_name = parts.shift
      last_name = parts.reject { |part| part == suffix }.join(" ")
      last_name = nil if last_name.empty?
    elsif prefix && parts.size == 1
      first_name = nil
      last_name = parts.first
    else
      first_name = parts.first
      last_name = nil
    end

    {
      prefix: prefix,
      first_name: first_name,
      last_name: last_name,
      suffix: suffix
    }
  end

  def parse_formatted(name, **options)
    parsed = parse(name, **options)
    {
      prefix: format_prefix(parsed[:prefix]),
      first_name: format_first_name(parsed[:first_name]),
      last_name: format_last_name(parsed[:last_name]),
      suffix: format_suffix(parsed[:suffix])
    }
  end

  def format(name, **options)
    parse_formatted(name, **options).values.compact.join(" ")
  end

  private

  def company_name?(name)
    [COMPANY_SUFFIX_REGEX, FAMILY_BUSINESS_REGEX, MULTIPLE_FAMILY_NAMES_REGEX,
      LAW_FIRM_REGEX, COMPANY_CO_REGEX, GROUP_HOLDINGS_REGEX,
      GEOGRAPHIC_COMPANY_REGEX, TRADING_ENTERPRISES_REGEX, DOUBLE_BARRELLED_NAME_REGEX].any? { |regex| name.match?(regex) }
  end

  def parse_company_name(name)
    parts = name.strip.split(/\s+/)
    suffix = extract_prefix_or_suffix(parts.reverse, SUFFIXES)
    {
      prefix: nil,
      first_name: nil,
      last_name: parts.reject { |part| part == suffix }.join(" "),
      suffix: suffix
    }
  end

  def extract_prefix_or_suffix(parts, list)
    list.each do |item|
      item_parts = item.split
      if item_parts.length <= parts.length
        potential_match = parts.take(item_parts.length).join(" ").delete(".")
        return parts.shift(item_parts.length).join(" ") if item.casecmp?(potential_match)
      end
    end
    nil
  end

  def format_first_name(name)
    return if name.nil?
    parts = name.split(/\s+|(?<=-)/)
    parts.map do |part|
      format_first_name_part(part)
    end.join(" ").gsub("- ", "-")
  end

  def format_first_name_part(part)
    case part.downcase
    when /^[od]'\w+/i
      part[0..1].capitalize + part[2..].capitalize
    else
      part.capitalize
    end
  end

  def format_last_name(name)
    return if name.nil?
    parts = name.split(/\s+|(?<=-)/)
    formatted_parts = []
    parts.each_with_index do |part, index|
      next_part = parts[index + 1]
      formatted_parts << format_last_name_part(part, next_part)
    end
    formatted_parts.join(" ").gsub("- ", "-")
  end

  def format_last_name_part(part, next_part)
    gaelic_formatter = GaelicNameFormatter.new(part)
    if gaelic_formatter.gaelic?
      return gaelic_formatter.format
    end

    case part.downcase
    when /^(v[ao]n|te|ter|de)$/i
      next_part&.match?(/der/i) ? part.downcase : part.capitalize
    when PARTICLE_REGEX
      next_part ? part.downcase : part.capitalize
    when /^dell'\w+/i
      part[0..4].capitalize + part[5..].capitalize
    when DUNAME_REGEX, DENAME_REGEX, /^[od]'\w+/i
      part[0..1].capitalize + part[2..].capitalize
    when /^von[r]+/i
      part[0..2].capitalize + part[3..].capitalize
    else
      part.capitalize
    end
  end

  def format_prefix(part)
    return if part.nil?
    part.split.map(&:capitalize).join(" ")
  end

  def format_suffix(part)
    return if part.nil?
    matched = SUFFIXES.find { |suffix| suffix.casecmp?(part.gsub(/\.$/, "")) }
    if matched
      return matched + (part.end_with?(".") ? "." : "")
    end
    part.end_with?(".") ? part.capitalize : part.upcase
  end
end
