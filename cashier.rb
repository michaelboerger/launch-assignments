puts "What is the amount due?"
amount_due = gets.chomp.to_f

puts "What is the amount tendered?"
tendered = gets.chomp.to_f

total =  tendered - amount_due
new_total = sprintf('%.2f', total)
other_total = sprintf('%.2f', total)
@time = Time.new.strftime("%D %H:%M")

if total < 0
  puts "WARNING CUSTOMER OWES YOU $#{new_total} MORE SCRILLA!"
else
puts "Thank You!"
puts "The total change due is $#{other_total}"
puts @time
end