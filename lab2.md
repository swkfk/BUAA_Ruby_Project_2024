# Ruby Case Equality 调研

在 Ruby 中，有一种设计独特的运算符：`===`，它同 JavaScript 中的 `===` 有很大不同，后者可以视作“同类型且相等”，但在 Ruby 中则不是这样：

<pre>
<b>irb(main):001></b> 1.0 === 1.0
=> <span style="color: green">true</span>
<b>irb(main):002></b> 1 + 2 === 3.0
=> <span style="color: green">true</span>
<b>irb(main):003></b> 3.0 === 3
=> <span style="color: green">true</span>
</pre>

显然后两个左右两个的类型不一样（甚至在 irb 里的颜色都不一样）。

## 不同资料对此的描述

在 10 年前出版的《Ruby 基础教程（第 4 版）》中，作者如是写到：

> 左边是数值或者字符串时，`===` 与 `==` 的意义是一样的，除此以外，`===` 还可以与 `=~` 一样用来判断正则表达式是否匹配，或者判断右边的对象是否属于左边的类，等等。对比单纯的判断两边的值是否相等，`===` 能表达更加广义的“相等”。

看上去描述得比较质朴，我又搜索了比较官方的 _"[The Ruby Programming Wikibook](https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Operators)"_，其中有这样的描述：

> "Case equality", "case subsumption" or "three equals" operator. A === B if B is a member of the set of A. Operation varies considerably depending on the data types of A and B.

它的描述也确实如此，操作会因为类型的不同而不同。但主体思路是，判断右边是否从某种意义上“是”左边。

官方库中，我发现一些作证上述说法的内容：

**`kernel.rb: class Kernel`**

```ruby
  # Case Equality -- For class Object, effectively the same as calling
  # <code>#==</code>, but typically overridden by descendants to provide
  # meaningful semantics in +case+ statements.
  def ===(other) end
```

根据注释的描述，从 `Object` 层面，它和 `==` 有一样的效果，但是会被继承者给重写，并且在 `case` 语句中，赋予它有意义的语义。

## 不同对象的不同语义

那就看一看它都有哪些常见的语义？

### 数值比较

**`integer.rb: class Integer`**

```ruby
  # Returns +true+ if +self+ is numerically equal to +other+; +false+ otherwise.
  #
  #   1 == 2     #=> false
  #   1 == 1.0   #=> true
  #
  # Related: Integer#eql? (requires +other+ to be an \Integer).
  #
  # Integer#=== is an alias for Integer#==.
  def ===(p1) end
  alias == ===
```

可以看到，对于整数来说，比较的是数值层面的相等，并且 `==` 是 `===` 的别名！

### 字符串比较

**`string.rb: class String`**

```ruby
  # Returns +true+ if +object+ has the same length and content;
  # as +self+; +false+ otherwise:
  #
  #   s = 'foo'
  #   s == 'foo' # => true
  #   s == 'food' # => false
  #   s == 'FOO' # => false
  #
  # Returns +false+ if the two strings' encodings are not compatible:
  #   "\u{e4 f6 fc}".encode("ISO-8859-1") == ("\u{c4 d6 dc}") # => false
  #
  # If +object+ is not an instance of \String but responds to +to_str+, then the
  # two strings are compared using <code>object.==</code>.
  def ==(other) end
  alias === ==
```

这里可以注意到，对于字符串来说 `==` 是 `===` 的别名。

上面的注释提到三件事：比较方法、编码对比较结果的影响、比较对象不是字符串怎么处理。

对于第三种情况，如果对方不是字符串，但是响应 `to_str` 方法，则会使用对方的 `==` 方法来进行比较，于是可以写一个简单的例子：

```ruby
class MyObject
  def ==(other)
    p "comparing by MyObject#== with #{other}"
    true
  end

  def to_str
    'MyObject'
  end
end

'AAA' === MyObject.new
```

运行上述代码，打印输出：

```
"comparing by MyObject#== with AAA"
```

与预期符合，真是有趣！

### 正则匹配

**`regexp.rb: class Regexp`**

```ruby
  # Returns +true+ if +self+ finds a match in +string+:
  #
  #   /^[a-z]*$/ === 'HELLO' # => false
  #   /^[A-Z]*$/ === 'HELLO' # => true
  #
  # This method is called in case statements:
  #
  #   s = 'HELLO'
  #   case s
  #   when /\A[a-z]*\z/; print "Lower case\n"
  #   when /\A[A-Z]*\z/; print "Upper case\n"
  #   else               print "Mixed case\n"
  #   end # => "Upper case"
  def ===(string) end
```

它这个描述得也很直白，便是检验一个字符串是否匹配自己。

### 类与对象

类自己的方法在 `class Class < Module` 中定义，于是有：

**`module.rb: class Module`**

```ruby
  # Case Equality---Returns <code>true</code> if <i>obj</i> is an
  # instance of <i>mod</i> or an instance of one of <i>mod</i>'s descendants.
  # Of limited use for modules, but can be used in <code>case</code> statements
  # to classify objects by class.
  def ===(obj) end
```

可以见得，可以使用 `String === "aaa"` 来判断某个对象或类是不是某个类或者它的继承者。

<pre>
<b>irb(main):001></b> Object === 1
=> <span style="color: green">true</span>
<b>irb(main):002></b> Numeric === 1
=> <span style="color: green">true</span>
<b>irb(main):003></b> Integer === 1
=> <span style="color: green">true</span>
<b>irb(main):004></b> 1 === Integer
=> <span style="color: red">false</span>
<b>irb(main):005></b> Object === Integer
=> <span style="color: green">true</span>
<b>irb(main):006></b> Integer === Object
=> <span style="color: red">false</span>
</pre>

### 一个更好理解的例子

只能说 `===` 并没有一个统一的语义，只是在很多时候有相似的表现，14 年前， StackOverflow 上有这样一个回答：

<https://stackoverflow.com/a/3422349>

> The best way to describe `a === b` is "if I have a drawer labeled a, does it make sense to put b in it?"

如果把 `b` 放进带有 `a` 标签的抽屉里是合理的，那么有 `a === b`。它很好地概括了整个过程。但也有一些需要注意的地方。

下面有一个例子，能够最为清晰地展现这一点：

<pre>
<b>irb(main):001></b> (1..3) === 2
=> <span style="color: green">true</span>
<b>irb(main):002></b> (1..3) === (1..3)
=> <span style="color: red">false</span>
<b>irb(main):003></b> (1..3) == 2
=> <span style="color: red">false</span>
<b>irb(main):004></b> (1..3) == (1..3)
=> <span style="color: green">true</span>
</pre>

但还有一点点问题，有下面这个例子：

<pre>
<b>irb(main):001></b> [1, 2, 3] === [1, 2, 3]
=> <span style="color: green">true</span>
<b>irb(main):002></b> [1, 2, 3] === 2
=> <span style="color: red">false</span>
</pre>

也许应该把 `[1, 2, 3]` 视作一个整体，而非表示“我能容纳 1 2 3 这三个数字”。

## `===` 与 `case` 语句

`case / when` 语句的底层基于 `===` 实现，相当于 `if-elsif-else` 的连续比较。

```ruby
case obj
when x1
  foo
when x2
  bar
default
  foobar
end
```

就相当于

```ruby
if x1 === obj
  foo
elsif x2 === obj
  bar
else
  foobar
end
```

但是前者更加简洁清晰。
