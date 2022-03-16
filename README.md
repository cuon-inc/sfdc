# Sfdc

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/sfdc`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sfdc'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sfdc

## Usage

### Initialization

Set the username, password, security token, client ID, client secret and API version in environment variables:

```bash
export SALESFORCE_USERNAME="username"
export SALESFORCE_PASSWORD="password"
export SALESFORCE_SECURITY_TOKEN="security token"
export SALESFORCE_CLIENT_ID="client id"
export SALESFORCE_CLIENT_SECRET="client secret"
export SALESFORCE_API_VERSION="41.0"
```

### Global configuration

You can set any logger globally:
```ruby
Sfdc.configure do |config|
  config.logger = Logger.new('/path/to/logfile')
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
