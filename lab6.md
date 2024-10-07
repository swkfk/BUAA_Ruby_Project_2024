# Rails 相关 Gem 包调研

查看 `rails` 依赖的 gem 包，有如下结果：

```
~> gem dependency rails
Gem rails-7.2.1
  actioncable (= 7.2.1)
  actionmailbox (= 7.2.1)
  actionmailer (= 7.2.1)
  actionpack (= 7.2.1)
  actiontext (= 7.2.1)
  actionview (= 7.2.1)
  activejob (= 7.2.1)
  activemodel (= 7.2.1)
  activerecord (= 7.2.1)
  activestorage (= 7.2.1)
  activesupport (= 7.2.1)
  bundler (>= 1.15.0)
  railties (= 7.2.1)

Gem rails-dom-testing-2.2.0
  activesupport (>= 5.0.0)
  minitest (>= 0)
  nokogiri (>= 1.6)
  rake (>= 0, development)

Gem rails-html-sanitizer-1.6.0
  loofah (~> 2.21)
  nokogiri (~> 1.14)
```

后面的 `rails-dom-testing` 与 `rails-html-sanitizer` 并不是需要讨论的 `rails`，但数目不多且有一定的关联性，可以一并讨论。

使用命令 `gem info xxx` 可以查看包 `xxx` 的基本信息，比如：

```
~> gem info rails

*** LOCAL GEMS ***

rails (7.2.1)
    Author: David Heinemeier Hansson
    Homepage: https://rubyonrails.org
    License: MIT
    Installed at: /home/kai/.local/share/gem/ruby/3.2.0

    Full-stack web application framework.
```

最后一行，告诉我们 `rails` 是一个全栈互联网框架。

## `rails`: `actioncable`

> **WebSocket** framework for Rails.

Action Cable 将 WebSocket 与 Rails 应用的其余部分无缝集成。在编程时，可以使用这个组件来实现**客户端与服务器端的实时通信**，并且具备高度的可拓展性与高性能。

Action Cable 通过 **Pub/Sub** （发布/订阅）的方式在服务器和多个客户端之间通信。

## `rails`: `actionmailbox`

> Inbound **email** handling framework.

Action Mailbox 用于接受电子邮件，入站的电子邮箱会被转变为 `InboundEmail` 记录，并直接和其他部分进行交互。

## `rails`: `actionmailer`

> Email composition and **delivery** framework (part of Rails).

Action Mailer 用于发送电子邮件，邮件由继承自 `ActionMailer::Base` 的邮件程序和视图控制。

## `rails`: `actionpack`

> Web-flow and rendering framework putting the VC in MVC (part of Rails).

Action Pack 是一个用来**处理并响应网络请求**的框架，它提供了处理路由、定义控制器并生成响应数据的机制。

Action Pack 由两部分组成：**Action Dispatch**，用于解析网络请求，并处理路由，以及与 http 相关的一些内容；**Action Controller**，提供控制器的基类，它们通常由视图自动生成。

## `rails`: `actiontext`

> **Rich text** framework.

为 rails 提供了富文本支持，同时也包含了一个叫做 `Trix` 的编辑器，可以处理诸如格式化、跳转至引用、列举嵌入图片等功能。并且生成可以与已有的 `Active Record` 模型兼容。

## `rails`: `actionview`

> Rendering framework putting the **V** in MVC (part of Rails).

处理视图模板与渲染，并提供了一些辅助方法来辅助 HTML 表单等内容的构建。

Action View 可以与 Action Controller 一起来处理网络请求。Action View 也使用 ERB 模板来提供了在 HTML 中使用 Ruby 代码的能力。

## `rails`: `activejob`

> **Job** framework with pluggable **queues**.

Active Job 框架可以用来生命一些任务，并使得它们可以在后台队列中运行。它可以运行常规的周期性任务，以及其他的可以被划分、且可以并行运行的任务。

后台任务的意义在于避免用户过长时间的等待，比如与 Action Mailer 联动时，可以在后台发送邮件而使用户无感。

Active Job 的后端队列是可替换的，而不需要改变现有的任务。

## `rails`: `activemodel`

> A toolkit for building modeling frameworks (part of Rails).

Active Model 提供了一套可以在模型中使用的接口，比如可以允许 Action Pack 和 Action View 与原生 Ruby 对象进行交互，或者创建自定义的 ORM.

Active Model 提供了一系列方法来构建 Ruby 模型，并使之能与数据库交互，而不用去操心其后端。

## `rails`: `activerecord`

> **Object**-relational **mapper** framework (part of Rails).

Active Record 将类与**关系型数据库**进行连接，并且构建一个无需配置的持久化应用层。

同时，这些可以成为一个模型，也可以是和其他模型的关联。

## `rails`: `activestorage`

> Local and cloud **file storage** framework.

Active Storage 提供了从本地或者云存储中进行文件交互的方式，它能够将这些文件绑定到 Active Record 上，并支持服务的冗余备份。

Active Storage 也支持本地的文件交互，并能够对图片进行基础的处理与调整。

## `rails`: `activesupport`

> A toolkit of **support libraries** and Ruby **core extensions** extracted from the Rails framework.

Active Support 提供了 Rails 的工具类套件，并提供了一个 Rails 拓展的标准库类。

它提供了一个语言层面的基准，用于 Rails 应用的构建，以及 RoR 本身的建立。

## `rails`: `bundler`

> The best way to **manage** your application's **dependencies**

用于依赖管理，新建 Rails 项目时，会自动使用 Bundler 下载并安装依赖。当然，使用 `--skip-bundle` 可以跳过这一个步骤。

## `rails-dom-testing`: `activesupport`

另见: [rails-activesupport](#rails-activesupport)

## `rails-dom-testing`: `minitest`

> minitest provides a complete suite of **testing facilities** supporting TDD, BDD, mocking, and benchmarking

这是一个测试库，提供了很多用于测试的套件，它可以支持测试驱动开发（TDD）、行为驱动开发（BDD）、数据伪造以及基准测试。

## `rails-dom-testing`: `nokogiri`

> Nokogiri (鋸) makes it easy and painless to work with XML and HTML from Ruby.

> nokogiri 看上去像罗马字，转成假名是 のこぎり，翻译一下是“锯子”？官方介绍就是这么写的诶！

Nokogiri 提供了容易理解、简单易用的接口，来读取、写入、修改 XML 或 HTML 文档，它可以依赖一些原生的解析库来提高性能和兼容性。

## `rails-dom-testing`: `rake`

> Rake is a **Make**-like program implemented in Ruby

适用于 Ruby 的 `make`，在 Rails 应用里面可以用来执行 Rakefile 中定义的非常多的操作，比如启动服务器、初始化数据库等等。

## `rails-html-sanitizer`: `loofah`

> Loofah is a general library for manipulating and transforming **HTML/XML** documents and fragments, built on top of Nokogiri.

基于 Nokogiri 建立的 HTML 与 XML 的处理库，可以很轻松地对它们进行处理。

比如可以检查不安全的 HTML 标签，移除标签属性，进行 HTML 转义等等。

## `rails-html-sanitizer`: `nokogiri`

另见: [rails-dom-testing-nokogiri](#rails-dom-testing-nokogiri)
