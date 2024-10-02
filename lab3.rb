def count_ones(n)
  n.digits(2).count { |x| x == 1 }
end
