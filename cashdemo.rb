input = nil
balance = 0
subtotal = []
t = Time.now # Time is a class

until input == "done"
  puts 'what is the sale price?'
  input = gets.chomp
  unless input == "done"
    subtotal.push(input.to_f)
    balance += input.to_f
    puts "Subtotal: $#{format("%.2f",balance)}"
  end
end

puts "Here are your item prices:"

subtotal.each do |coffee|
  puts "$#{format("%.2f",coffee)}"

end
puts ''
puts "Total amount due is: $#{format("%.2f",balance.abs)}"

#--------------------------------------------------------------

puts 'What is the amount tendered?'
tendered = gets.chomp.to_f

change = tendered - balance

if change < 0
  puts "WARNING: Customer still owes $#{format("%.2f",change.abs)} Exiting..."
  end

  if change >= 0
  puts '===Thank You!==='
  puts "The total change due is $#{format("%.2f",change)}"
  puts ''

  puts t.strftime("%D %I:%M %p")

  puts '=================='
end