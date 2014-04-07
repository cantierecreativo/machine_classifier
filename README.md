# MachineClassifier

MachineClassifier is a thin wrapper around the APIs used to
call machine learning classification systems.

Currently, only Google Prediction is supported.

## Installation

Add this line to your application's Gemfile:

    gem 'machine_classifier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install machine_classifier

## Usage

### Google Prediction

```ruby
require 'machine_classifier'

text = 'Some text that I want to classify'

configuration = MachineClassifier::Configuration.new do |conf|
  conf.api_version           = '1.6'
  conf.developer_email       = 'developer_email@example.com'
  conf.private_key           = 'Binary data'
  conf.private_key_password  = 'private_key_password'
  conf.project               = 'Google Prediction Project Name'
  conf.model                 = 'Google Prediction Model'
  conf.application_name      = 'My Appliction'
  conf.application_version   = '1.0.0'
end

client = MachineClassifier::Client.new(configuration)
result = client.call(text)
raise 'Classification call failed' if not result.success?
puts "Text: #{text}"
puts "Label: #{result.winner}"
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/machine_classifier/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
