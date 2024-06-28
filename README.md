![Status Badge](https://github.com/kylewelsby/name_formatter/actions/workflows/main.yml/badge.svg)

# NameFormatter

NameFormatter is a Ruby gem that provides robust name parsing and formatting capabilities. It handles a wide variety of name formats, including personal names from different cultures, company names, and names with prefixes and suffixes.

## ✨ Features

- Handles personal names from various cultures (Western, Spanish, German, etc.)
- Supports company names and legal entities
- Correctly formats prefixes, suffixes, and particles (e.g., "van", "de", "von")
- Preserves capitalization for names like "McDonald" or "DeVito"
- Unicode-aware, handling names with non-ASCII characters

## 🎲 Installation

Add this line to your application's Gemfile:

```ruby
gem 'name_formatter'
```

and then execute:

```bash
bundle install
```

or install it yourself as:

```bash
gem install name_formatter
```

## 🛠️ Usage

```ruby
require 'name_formatter'

formatter = NameFormatter.new

# Format a name
formatted = formatter.format("JOHN DOE")
puts formatted  # Output: "John Doe"

# Parse and Format a name
parsed = formatter.parse_formatted("Dr. Jane Smith Jr.")
puts parsed
# Output: {
#   prefix: "Dr.",
#   first_name: "Jane",
#   last_name: "Smith",
#   suffix: "Jr."
# }

# Parse skip formatting a name
parsed = formatter.parse("Dr. Jane Smith Jr.")
puts parsed
# Output: {
#   prefix: "Dr.",
#   first_name: "Jane",
#   last_name: "Smith",
#   suffix: "Jr."
# }

# Handle complex names
puts formatter.format("MARÍA DEL CARMEN MARTÍNEZ-VILLASEÑOR")
# Output: "María del Carmen Martínez-Villaseñor"

# Handle company names
puts formatter.format("ACME CORPORATION, INC.")
# Output: "Acme Corporation, Inc."
```


## 👨‍💻 Development

TODO

## 🤝 Contributing

Bug reports and pull requests are welcome on GitHub at [github.com/kylewelsby/name_formatter](https://github.com/kylewelsby/name_formatter).

## 🎓 License

This gem is available as open source under ther terms of the MIT License.

https://kylewelsby.mit-license.org

