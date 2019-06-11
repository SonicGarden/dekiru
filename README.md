# できる！Rails

[![Build Status](https://travis-ci.org/mataki/dekiru.svg?branch=master)](https://travis-ci.org/mataki/dekiru)

Usefull Helper methods for Ruby on Rails

## Rails version support

Rails 5.1 は ~> 0.1.0

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

## Capybara Matchers

以下の設定をすると Capybara 用のマッチャーが使えるようになる。

```ruby
require 'dekiru/capybara/matchers'
RSpec.configure do |config|
  config.include Dekiru::Capybara::Matchers, type: :feature
end
```

### examples

```ruby
# javascriptエラーがあったらテスト失敗するように
RSpec.configure do |config|
  config.after(:each, type: :feature) do |example|
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

## Mail Security Hook

以下の設定をすると、宛先を指定しないメールを配信しようとした時に`Dekiru::MailSecurityInterceptor::NoToAdreessError`例外を発生させる。

※ to に空文字や空配列を指定してメールを配信しようとすると、bcc 内のアドレスが to に転記されるといった問題がある。これを未然に防ぐことができる。

```ruby
# config/initializer/dekiru.rb
Dekiru.configure do |config|
  config.mail_security_hook = true # default: false
end
```

## Data Migration Operator

実行しながら進捗を表示したり、処理の最後に実行の確認をしたりといった、データ移行作業をするときに必要な処理を以下のような script を作成することで、実現できるようになります。

```ruby
# scripts/demo.rb
Dekiru::DataMigrationOperator.execute('Demo migration') do
  targets = User.where("email LIKE '%sonicgarden%'")

  log "all targets count: #{targets.count}"
  find_each_with_progress(targets) do |user|
    user.update(admin: true)
  end

  log "updated user count: #{User.where("email LIKE '%sonicgarden%'").where(admin: true).count}"
end
```

```
$ bin/rails r scripts/demo.rb
Start: Demo migration at 2019-05-24 18:29:57 +0900

all targets count: 30
Time: 00:00:00 |=================>>| 100% Progress
updated user count: 30

Are you sure to commit? (yes/no) > yes

Finished successfully: Demo migration
Total time: 6.35 sec
```

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
