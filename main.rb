require './product'
require './promotion'
require './shoppingCart'

#ToDo
#buy multiple products
#Promo type2

$products = []
$promotions = []
#instances
$products << Product.new('Naranja', 350, 'unidad')
$products << Product.new('Guisantes', 1000, 'unidad')
$products << Product.new('Pechuga',14000, 'kilo')

$promotions << Promotion.new({'product' => $products[0], 'new_price' => 266, 'prom_qty' => 3, 'type' => 1})
$promotions << Promotion.new({'product' => $products[1], 'new_price' => 0, 'prom_qty' => 3, 'pay_qty' => 2 ,'type' => 2})

$sCart = ShoppingCart.new

def buy
	showProductOptions 'comprar'
	choose = gets.chomp
	while(choose != 's')
		if choose == 'p'
			$sCart.showCart
			pause
			cls
		elsif choose == 'f'
			cls
			$sCart.endPurchase
			pause
			cls
			break
		else
			choose = choose.to_i
			if choose >= 1 and choose <= $products.length
				product_index = choose - 1
				puts "Ingrese la cantidad a comprar (#{$products[product_index].unit})"
				qty = gets.chomp.to_i
				price = addToCart($products[product_index], qty)
				puts "El precio por este producto es $#{price} "
			else
				puts "Opción incorrecta"
			end
		end
		showProductOptions 'comprar'
		choose = gets.chomp
	end
end

def addToCart(product, qty)
	if product.productHasPromo?
		promo = getPromo product
		qty_values = calcPromoPriceAndQtys(promo, product, qty)
		if qty_values['product_qty'] != 0
			$sCart.addToCart(product.name, product.price, qty_values['product_qty'], product.unit)
		end
		if qty_values['promo_qty'] != 0
			$sCart.addToCart(product.name, promo.new_price, qty_values['promo_qty'], product.unit)
		end
		price = product.price * qty_values['product_qty'] + promo.new_price * qty_values['promo_qty']
		return price
	else
		$sCart.addToCart(product.name, product.price, qty, product.unit)
		price = qty * product.price
		return price
	end
end


def calcPromoPriceAndQtys(promo, product, qty)
	promo_product_qty = 0
	regular_product_qty = 0

	if promo.type == 1 #Example Oranges option
		promo_product_qty = (qty / promo.prom_qty).to_i * promo.prom_qty
		regular_product_qty = qty - promo_product_qty
	end
	if promo.type == 2 #Example peas option
		free_products = promo.prom_qty - promo.pay_qty
		promo_product_qty = (qty / promo.prom_qty).to_i * free_products
		regular_product_qty = qty - promo_product_qty
	end

	prices_and_qtys = {'promo_qty' => promo_product_qty, 'product_qty' => regular_product_qty}
	return prices_and_qtys
end


def getPromo product
	$promotions.each do |promo|
		if(promo.product == product)
			return promo
		end
	end
end

def showProductOptions action
	puts "\n\n"
	puts "Seleccione el producto a #{action}"
	puts "Ingrese el caracter correspondiente a alguna de las opciones"
	showAllProducts
	if action == 'Comprar'
		puts "p. Preview de la compra"
		puts "f. Finalizar compra"
	end
	puts "s. Salir"

end

def showPromoOptions action
	puts "\n\n"
	puts "Seleccione la promocion a #{action}"
	puts "Ingrese el caracter correspondiente a alguna de las opciones"
	showAllPromotions
	puts "s. Salir"

end


def showAllProducts all_info = false
	if all_info
		puts 'Productos disponibles'
		$products.each_with_index do |product, i|
			puts "#{i+1}. #{product.productInfo} "
		end
	else
		$products.each_with_index do |product, i|
			puts "#{i+1}. #{product.name} "
		end
	end
end

def showAllPromotions all_info = false
	if all_info
		puts 'Promociones creadas'
		$promotions.each_with_index do |promo, i|
			puts "#{i+1}. #{promo.promotionInfo}"
		end
	else
		$promotions.each_with_index do |promo, i|
			puts "#{i+1}. #{promo.product.name}"
		end
	end
end

def mainMenu
	showMainMenu
	choose = gets.chomp
	while(choose != 's')
		case choose
		when '1'
			cls
			buy
		when '2'
			cls
			addProduct
		when '3'
			cls
			deleteProduct
		when '4'
			addPromotion
			cls
		when '5'
			deletePromotion
			cls
		when '6'
			showAllProducts all_info = true
			showAllPromotions all_info = true
			pause
			cls
		else
			'Opción incorrecta'
		end
		showMainMenu
		choose = gets.chomp
	end

end

def addProduct
	puts 'Ingrese el nombre del producto'
	name = gets.chomp
	puts 'Ingrese el precio del producto'
	price = gets.chomp.to_i
	puts 'Ingrese las unidades del producto'
	units = gets.chomp
	$products << Product.new(name, price, units)
	puts "Se ha agregado el producto #{name} exitosamente"
	pause
end

def deleteProduct
	showProductOptions 'eliminar'
	choose = gets.chomp
	if choose != 's'
		choose = choose.to_i
		if choose >= 1 and choose <= $products.length
			product_index = choose - 1
			d_pruduct_name = $products[product_index].name
			$products.delete_at(product_index)
			puts "Se ha borrado el producto #{d_pruduct_name} exitosamente"
			pause
		else
			puts "Opción incorrecta"
			pause
		end
	end
end

def addPromotion
	showProductOptions 'agregar promoción'
	choose = gets.chomp
	if choose != 's'
		choose = choose.to_i
		if choose >= 1 and choose <= $products.length
			product_index = choose - 1
			new_promo_pruduct = $products[product_index]

			puts 'Ingrese el tipo de la promoción 1 o 2'
			type = gets.chomp.to_i
			if type != 1 && type != 2
				puts 'Número incorrecto, se pondra la promoción por defecto (1)'
				type = 1
			end
			if type == 1
				puts 'Ingrese el nuevo precio del producto'
				new_price = gets.chomp.to_i
				puts 'Ingrese la cantidad de productos para aplicar la promo'
				qty = gets.chomp.to_i
				$promotions << Promotion.new({'product' => new_promo_pruduct, 'new_price' => new_price, 'prom_qty' => qty, 'type' => type})
			end

			if type == 2
				puts 'Ingrese la cantidad a pagar'
				pay_qty = gets.chomp.to_i
				puts 'Ingrese la cantidad llevar'
				bring_qty = gets.chomp.to_i
				$promotions << Promotion.new({'product' => new_promo_pruduct, 'new_price' => 0, 'prom_qty' => bring_qty, 'pay_qty' => pay_qty, 'type' => type})
			end
			puts "Se ha agregado la promo al el producto #{new_promo_pruduct.name} exitosamente"
			pause
		else
			puts "Opción incorrecta"
			pause
		end
	end
end

def deletePromotion
	showPromotionOptions 'eliminar'
	choose = gets.chomp
	if choose != 's'
		choose = choose.to_i
		if choose >= 1 and choose <= $promotions.length
			promotion_index = choose - 1
			d_pruduct_promo = $promotions[promotion_index].product
			$promotions[promotion_index].product.has_promo = false
			$promotion.delete_at(promotion_index)
			puts "Se ha borrado la promocion del producto #{d_pruduct_promo.name} exitosamente"
			pause
		else
			puts "Opción incorrecta"
			pause
		end
	end
end

#mainMenu
def showMainMenu
	puts "\n\n"
	puts "Seleccione la opción a realizar"
	puts "Ingrese el caracter correspondiente a alguna de las opciones"
	puts "1. Realizar Venta"
	puts "2. Agregar Producto"
	puts "3. Eliminar Producto"
	puts "4. Agregar Promoción"
	puts "5. Eliminar Promoción"
	puts "6. Mostrar productos y promociones"
	puts "s. Salir"
end

def cls
  system('cls')
end

def pause
	system("PAUSE")
end
#Code Begin
mainMenu
