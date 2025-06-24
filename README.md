# できる！Rails

[![Build Status](https://travis-ci.org/mataki/dekiru.svg?branch=master)](https://travis-ci.org/mataki/dekiru)

Useful Helper methods for Ruby on Rails

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
  config.include Dekiru::Capybara::Helpers, type: :system
end
```

### examples

```ruby
# アニメーション終了待ちヘルパー(アニメーション中のクリックは失敗することがある)

# CSSセレクタで指定した要素の位置が動かなくなるまで待つ
wait_for_position_stable(:css, '[data-test-id="confirmation-modal"]')
click_button 'OK'

# チェックボックスの位置が0.5秒間停止し続けるまで待つ
# タイムアウトは5秒
wait_for_position_stable(:checkbox, 'Red', wait: 5, stable_wait: 0.5)
check 'Red'

# findした要素を指定してアニメーション終了待ち
element = find('[data-test-id="confirmation-modal"]')
wait_for_element_position_stable(element)
```

## Capybara Matchers

以下の設定をすると Capybara 用のマッチャーが使えるようになる。

```ruby
require 'dekiru/capybara/matchers'
RSpec.configure do |config|
  config.include Dekiru::Capybara::Matchers, type: :system
end
```

### examples

```ruby
# javascriptエラーがあったらテスト失敗するように
RSpec.configure do |config|
  config.after(:each, type: :system) do |example|
    if example.metadata[:js] == true
      expect(page).to have_no_js_errors
    end
  end
end
```

## Rake Task

以下の設定をすると Rake タスクの実行前後にログ出力されるようになる。(Ruby2.4 以降が必要)

In Rakefile:

```ruby
require_relative 'config/application'
require 'dekiru/task_with_logger'

Rails.application.load_tasks
```

In myapp.rake:

```ruby
using TaskWithLogger

namespace :myapp do
  desc 'dekiru'
  task dekiru: :environment do
    puts 'dekiru'
  end
end
```

以下の設定をすると db:migrate タスクの実行前に競合がチェックされる。

In Rakefile:

```ruby
require_relative 'config/application'

Rails.application.load_tasks
Rake::Task['db:migrate'].enhance(['db:migrate:check_conflict']) if Rails.env.development?
```

## Data Migration Operator

For data migration operations, please use the separate [`dekiru-data_migration` gem](https://github.com/SonicGarden/dekiru-data_migration) which provides the `Dekiru::DataMigrationOperator` functionality.

## Refinements

### Dekiru::CamelizeHash

```ruby
using Dekiru::CamelizeHash

{ dekiru_rails: true }.camelize_keys(:lower)
# => { dekiruRails: true }

{ dekiru_rails: { dekiru_rails: true } }.deep_camelize_keys(:lower)
# => { dekiruRails: { dekiruRails: true } }
```

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Added some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request
