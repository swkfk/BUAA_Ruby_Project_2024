def get_array()
  gets.chomp.split(' ')
end

puts Hash[get_array.zip(get_array)]
