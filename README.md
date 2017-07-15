# Typical

This library provides a DSL to describe the types of your data and ways to validate them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "typical"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install typical

## Usage

### DSL

To specify type information, you can use the `Gravitype::Type::DSL` module.

```ruby
include Gravitype::Type::DSL
```

The bang methods are used to define types.

```ruby
String!                    # => #<Type:String>
```

You can allow multiple types by creating a union of them.

```ruby
String! | Integer!         # => #<Type:Union [#<Type:String>, #<Type:Integer>]>
```

Sometimes a field can also be null.

```ruby
String! | Integer! | null  # => #<Type:Union [#<Type:String>, , #<Type:Integer>, #<Type:NilClass>]>
```

If you’re defining a single type, but nullable, use the question mark methods instead.

```ruby
String?                    # => #<Type:Union [#<Type:String>, #<Type:NilClass>]>
```

You can have collections too, you use them like you normally would.

```ruby
Set!(String!, Integer!)    # => #<Type:Set [#<Type:Union [#<Type:String>, #<Type:Integer>]>]>
Array!(String!, Integer!)  # => #<Type:Array [#<Type:Union [#<Type:String>, #<Type:Integer>]>]>
Hash!(String! => Integer!) # => #<Type:Hash { [#<Type:Union [#<Type:String>]>] => [#<Type:Union [#<Type:Integer>]>] }>
```

### Validation

_NOTE: This is not yet implemented._

```ruby
typing = Array!(String!)
typing.valid?("string")    # => false
typing.valid?([nil])       # => false
typing.valid?([])          # => true
typing.valid?(["string"])  # => true
```

### Mongoid

_NOTE: This is not yet implemented._

This Mongoid integration allows you to both reflect on the data types in your database and validate incoming data.

```ruby
class Artist
  include Mongoid::Document
  include Gravitype::Type::DSL

  field :name, type: String?
  field :image_versions, type: Array!(Symbol!)
  field :image_urls, type: Hash!(String! => String!)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alloy/typical.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

