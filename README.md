# できる！Rails

[![Build Status](https://travis-ci.org/mataki/dekiru.svg?branch=master)](https://travis-ci.org/mataki/dekiru)

Usefull Helper methods for Ruby on Rails

## Installation

Add this line to your application's Gemfile:

    gem 'dekiru'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dekiru

## Capybara Helpers

以下の設定をすると Capybara 用のヘルパーメソッドが使えるようになる。

```ruby
require 'dekiru/capybara/helpers'
RSpec.configure do |config|
  config.include Dekiru::Capybara::Helpers, type: :feature
end
```

### examples

```ruby
# Ajax処理の終了待ち
click_link 'Ajax link!'
wait_for_ajax
expect(page).to have_content 'created element!'

# Bootstrap3 のモーダルの出現終了待ち(待たないとモーダル内のノードのクリックに失敗することがある)
wait_for_event('shown.bs.modal') do
  click_link 'Open bootstrap3 modal'
end
click_on 'Button in modal'
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
