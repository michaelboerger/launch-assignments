require 'csv'
require 'pry'
require 'date'
#Repository at https://github.com/bjornlinder/launch/blob/master/cashier/cashier3.rb
def prompt(output)
  puts "#{output}"
  gets.chomp
end

def format_currency(currency)
  "$"+sprintf('%.2f', currency)
end

puts "Welcome to Michael & Bjorn's Coffee House"

menu=["1) Add item - $5.00 - Light", "2) Add item - $7.50 - Medium", "3) Add item - $9.75 - Bold", "4) Complete Sale", "5) Reporting"]
puts menu

Products=Struct.new(:item,:SKU,:retail,:wholesale)

File.open("products.csv",'r')

@products=[]

CSV.foreach('products.csv', headers: true) do |row|
  products=Products.new(item: row[1],SKU: row[0],row[3].to_f,row[2].to_f)
  @products<<products
end

def first_input
  selection=prompt("Make a selection").to_i
  if selection==5
    report_sales_data_to_boss_person()
  elsif (1..3).include?(selection)
    order_array = Array.new(3,0)
    order=ordering(selection,order_array)
  else wrong(true)
  end
  return order
end

def wrong(bool)
  puts "You lose. Would you like to try again?"
  bool ? first_input : true
end

def ordering(selection, order)
  if (1..3).include?(selection)
    quantity=prompt("How Many?").to_i
    order[selection-1]+=quantity
    puts "Subtotal: #{format_currency(subtotal(order))}"
    selection=prompt("Make a selection").to_i
    ordering(selection,order)
  elsif selection==4
   order.each_with_index {|a,i| print "#{format_currency(a*@products[i][2])} - #{a} #{@products[i][0]} \n" if a!=0}
    take_change(order)
  else
    wrong(false)
    selection=prompt("Make a selection").to_i
    ordering(selection,order)
  end
end

def save_order_data(order,argument_2)
  File.open("sales.csv",'ab') do |csv|
    order.each_with_index do |row,index|
      sales=[@products[index][1],order[index],Time.now.strftime("%D")]
      csv<<CSV.generate_line(sales) if sales[1]!=0
    end
  end
end
class Reporting
  @products=[]
  def report_sales_data_to_boss_person
    File.open("sales.csv",'r')
    date=prompt ("What date would you like reports for? (MM/DD/YY)")
    print "On #{date} we sold: \n"
    sales_by_date=Array.new($products.length,0)
    CSV.foreach('sales.csv', headers: true) do |row|
        if row[2]==date
          @products.each_with_index do |x,index|
            sales_by_date[index]+=row[1].to_i if row[0]==@products[index][1]
          end
        end
      end
      total_sales=0
      total_profit=0
      sales_by_date.each_with_index do |x, i|
        revenue=@products[i][2]*x
        total_sales+=revenue
        profit=(revenue-@products[i][3]*x)
        total_profit+=profit
        puts "SKU: #{@products[i][1]}, Name: #{@products[i][0]}, Quantity: #{x}, Revenue: #{format_currency(revenue)}, Profit: #{format_currency(profit)}" if x!=0
      end
      puts "\nTotal Sales: #{format_currency(total_sales)}"
      puts "Total Profit: #{format_currency(total_profit)}"
  end

  def take_change(order)
    still_owed=subtotal(order)
    puts "The total amount due is #{format_currency(still_owed)}"
    loop do
        amount_tendered = prompt("What is the amount tendered?").to_f
        still_owed -= amount_tendered
        break if still_owed <= 0
        puts "WARNING: Customer still owes #{format_currency(still_owed)}!"
    end
    change_due_successful_output(still_owed)
    save_order_data(order)
  end
end


def change_due_successful_output(change)
  puts "===Thank You!==="
  puts "The total change due is #{format_currency(change.abs)}\n"
  puts "#{Time.now.strftime("%F %I:%M %p")}"
end

def subtotal(array)
  array.each_with_index.inject(0) { |subtotal, (quantity, i)| subtotal + quantity*@products[i][2]}
end

first_input