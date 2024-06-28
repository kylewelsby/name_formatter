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

1. Run the tests to ensure everything is setup correctly:

```ruby
ruby -Ilib test/*.rb
```

2. To run an interactive prompt that will allow you to expriement with the code, you can use:

```ruby
irb -Ilib -rname_formatter
```

Remember to add tests for new features or bugs fixes.

## 🤝 Contributing

Bug reports and pull requests are welcome on GitHub at [github.com/kylewelsby/name_formatter](https://github.com/kylewelsby/name_formatter).

## 🚀 Releasing

To release a new version:

1. Update the version number in `lib/name_formatter/version.rb`
2. Update `CHANGELOG.md`
3. Commit changes
4. Create a new tag with `git tag -a vX.X.X -m "Release X.X.X"`
5. Push the tag with `git push origin vX.X.X`

GitHub Actions will automatically build and publish the gem oto RubyGems.org when the tag is pushed.


### If the release fails

If the tests fail during the release process:

1. Fix the failing tests
2. Commit your changes
3. Update the tag
```
git tag -fa vX.X.X -M "Update release X.X.X"
```
4. Force-push the update tag:
```
git push origin vX.X.X --force
```

This will trigger the release process again with the updated code.

Remember, force-pushing a tag can cause issues if others have already pulled that tag, so it's generally best to use this approach only for fixing issues with releases that haven't been widely distributed yet.

For more significant changes, it might be better to increment the version number (e.g., from 0.1.0 to 0.1.1) and create a new tag instead of updating the existing one.

## 🎓 License

This gem is available as open source under ther terms of the MIT License.

https://kylewelsby.mit-license.org

