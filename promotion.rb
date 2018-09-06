class Promotion
	attr_reader :product, :new_price, :prom_qty, :pay_qty, :type
	def initialize(args)
		@product = args['product']
		@new_price = args['new_price']
		@prom_qty = args['prom_qty']
		@pay_qty = args['pay_qty'] unless args['pay_qty'].nil?
		@type = args['type']
		@product.has_promo = true;
	end
	def promotionInfo
		"#{@product.name} #{@new_price} #{@prom_qty} #{@pay_qty unless @pay_qty.nil?}  "
	end
end