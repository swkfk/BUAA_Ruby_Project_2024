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
