def decode_ways(code)
  return 0 unless code.positive?

  code = code.to_s
  array = [code[0] == '0' ? 0 : 1]

  (1...code.length).each do |i|
    current_zero = code[i] == '0'
    straight_legal = code[i - 1] == '1' || (code[i - 1] == '2' && code[i] <= '6')
    case [current_zero, straight_legal]
    when [true, true]
      array << (array[-2].nil? ? 1 : array[-2])
    when [true, false]
      array << 0
    when [false, true]
      array << array[-1] + (array[-2].nil? ? 1 : array[-2])
    when [false, false]
      array << array[-1]
    else
      raise 'unreachable code'
    end

    return 0 if array[-1].zero?
  end
  array[-1]
end
