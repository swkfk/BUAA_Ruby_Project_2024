# Rails 启动过程调研

## Rails 对命令的解析与服务器的启动

`rails` 是 `bin` 目录下的一个 Ruby 程序，在其中会引用 `rails/commands`，其中包含了 rails 的启动代码。它会通过下列代码执行给予 rails 的命令，如 `server`：

```ruby
Rails::Command.invoke command, ARGV
```

在 `invoke` 方法中，rails 会查找它，如果是 rails 相关命令，则调用其 `perform` 方法，否则则通过 `invoke_rake` 方法，交由 `rake` 处理。

```ruby
def invoke(full_namespace, args = [], **config)
  # == snipped ==
          if command && command.all_commands[command_name]
            command.perform(command_name, args, config)
          else
            invoke_rake(full_namespace, args, config)
          end
  # == snipped ==
end
```

对于 `rails server` 命令，实际执行的是 `Rails::Command::ServerCommand#perform` 方法。在其中，会执行三步操作：

- `set_application_directory!` 找寻 `config.ru` 相关的路径，并设置为工作目录
- `prepare_restart` 似乎是为重启做准备，大抵是删除与进程 ID 有关的一个文件
- 启动服务器，这个服务器继承自 `Rackup::Server`

在这里有一堆复杂的、没有注释的、很难快速理解的代码，姑且参考一下：

<https://ruby-china.github.io/rails-guides/v4.1/initialization.html>

的内容，虽然这片指南很老，并且和我机器中安装的 rails 代码并不完全一致。

经过一些列初始化，执行 `Rails::Server#start` 方法启动服务器：

```Ruby
def start(after_stop_callback = nil)
  trap(:INT) { exit }
  create_tmp_directories
  setup_dev_caching
  log_to_stdout if options[:log_stdout]

  super()
ensure
  after_stop_callback.call if after_stop_callback
end
```

这里首先捕获 `INT` 信号，使得我们可以通过 `Ctrl+C` 优雅地终止服务器；然后创建了一些临时文件夹；并设置了开发模式下的缓存；最后调用父类（Rackup 的 `Server`）的 `start` 方法，创建应用程序，并最终启动服务器：

```Ruby
server.run(wrapped_app, **options, &block)
```

在创建应用程序（`build_app`）时，会从 `config.ru` 中获取内容，其中包含了 `config/environment.rb`，并进而引用了 `config/application.rb`，进一步引用 `config/boot.rb`。

`config/application.rb` 中会包含 `rails/all`,它会导入所有的框架：

```Ruby
%w(
  active_record/railtie
  active_storage/engine
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  action_cable/engine
  action_mailbox/engine
  action_text/engine
  rails/test_unit/railtie
).each do |railtie|
  begin # rubocop:disable Style/RedundantBegin
    require railtie
  rescue LoadError
  end
end
```

在 `rails/environment.rb` 中，会使用这一条语句初始化应用程序：

```Ruby
Rails.application.initialize!
```

在初始化完成之后，会回到 `Rack::Server` 中，完成剩下的代码，启动一个具体的服务器，比如 `Puma`。

接着，代码进入到 `Puma` 中，大抵会执行 `Puma::RackHandler#run` 方法（动态类型，只阅读代码的话不是很确定）：

```Ruby
def run(app, **options)
  conf = self.config(app, options)

  log_writer = options.delete(:Silent) ? ::Puma::LogWriter.strings : ::Puma::LogWriter.stdio

  launcher = ::Puma::Launcher.new(conf, :log_writer => log_writer, events: @events)

  yield launcher if block_given?
  begin
    launcher.run
  rescue Interrupt
    puts "* Gracefully stopping, waiting for requests to finish"
    launcher.stop
    puts "* Goodbye!"
  end
end
```

其中，调用 `launcher.run` 启动服务器，这个方法会阻塞整个流程，直到服务器退出。

## 端口监听与 http 解析

在 `Puma::Request` 中有一系列用于解析 http 请求头与请求体的方法，按照一般流程，它会解析请求的路由，并根据具体情况发送给具体的 rails 应用程序处理。
