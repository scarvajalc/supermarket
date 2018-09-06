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
		"Nombre: " + @name + ", Precio: " + @price.to_s + ", Unidades:" + @unit + (@has_promo ? ', tiene promoción' : '')
	end

	def productHasPromo?
		@has_promo
	end

	def ==(another_product)
    	self.name == another_product.name
  	end
end