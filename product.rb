class Product
	attr_reader :name, :price, :unit
	attr_accessor :has_promo
	def initialize(name, price, unit)
		@name = name
		@price = price
		@unit = unit
		@has_promo = false
	end

	def productInfo
		@name + " " + @price.to_s + " " + @unit
	end

	def productHasPromo?
		@has_promo
	end

	def ==(another_product)
    	self.name == another_product.name
  	end
end