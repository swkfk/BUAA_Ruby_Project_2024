def mfp(m)
  sum = (1..m).map do |x|
    x.to_s.chars
     .map(&:to_i)
     .filter(&:positive?)
     .inject(&:*)
  end.inject(&:+)

  ans = sum.even? ? 2 : 1
  sum /= 2 while sum.even? && sum > 1

  (3..).step(2).each do |i|
    break if i > Math.sqrt(sum)

    ans = i if (sum % i).zero?
    sum /= i while (sum % i).zero?
  end

  sum > 1 ? sum : ans
end
