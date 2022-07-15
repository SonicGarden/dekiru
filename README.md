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
  config.include Dekiru::Capybara::Helpers, type: :feature
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

また`warning_side_effects: true`オプションを付けて実行することで、データ移行作業で発生した副作用が表示されるようになります。

```ruby
Dekiru::DataMigrationOperator.execute('Demo migration', warning_side_effects: true) do
  # ...
end
```

```
$ bin/rails r scripts/demo.rb
Start: Demo migration at 2019-05-24 18:29:57 +0900

all targets count: 30
Time: 00:00:00 |=================>>| 100% Progress
updated user count: 30

Write Queries!!
30 call: Update "users" SET ...

Enqueued Jobs!!
10 call: NotifyJob

Deliverd Mailers!!
10 call: UserMailer

Are you sure to commit? (yes/no) > yes
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
