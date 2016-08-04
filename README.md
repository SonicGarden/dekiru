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

## Usage

以下のコマンドを実行すると、監視のための設定ファイルが自動的に生成される。

```
bin/rails g dekiru
```

メールアドレス、例外時の処理などは必要に応じて変更する。

```
Dekiru.configure do |config|
  config.monitor_email   = "email@example.com"
  config.monitor_api_key = "xxxxx-xxxx-xxxx-xxxx-xxxxxxxxx"
  config.error_handle    = -> (e) { Bugsnag.notify(e) }
end
```

Rakefile にて、'dekiru/rake_monitor' を読み込む。

```
require 'dekiru/rake_monitor'
```

rake で、`task_with_monitor` を使ってタスクを記述することで、 task を監視することができます。

```
task_with_monitor job: :environment, estimate_time: 10 do
  puts "execute"
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
