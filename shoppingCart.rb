class ShoppingCart
	attr_accessor :cart
	def initialize
		@cart = []
	end

	def addToCart name, unit_price, qty, unit
		cart << ShoppingElement.new(name, unit_price, qty, qty * unit_price, unit)
	end

	def showCart
		puts '----------------------------------------------------'
		@cart.each do |element|
			puts "#{element.name} .....#{element.unit_price} (#{element.unit}) x #{element.qty} .... = #{element.total_price}"
		end
		total = calculateTotal
		
		puts '......................................................'
		puts "                                      TOTAL: $#{total}"
		puts '......................................................'
		puts '------------------------------------------------------'
	end

	def cleanCart
		@cart = []
	end

	def calculateTotal
		total = 0
		@cart.each do |element|
			total += element.total_price
		end
		return total
	end

	def endPurchase
		showCart
		puts "POR FAVOR ENTREGUE $#{calculateTotal} AL CAJERO"
		puts "GRACIAS POR SU COMPRA, VUELVA PRONTO"
		cleanCart
	end
end

class ShoppingElement
	attr_reader :name, :unit_price, :qty, :total_price, :unit
	def initialize(name, unit_price, qty, total_price, unit)
		@name = name
		@unit_price = unit_price
		@qty = qty
		@total_price = total_price
		@unit = unit
	end
end