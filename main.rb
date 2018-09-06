require './product'
require './promotion'

#ToDo
#buy multiple products
#Promo type2

$products = []
$promotions = []

$products << Product.new('Naranja', 350, 'unidad')
$products << Product.new('Guisantes', 1500, 'unidad')
$products << Product.new('Pechuga',14000, 'kilo')


$promotions << Promotion.new({'product' => $products[0], 'new_price' => 230, 'prom_qty' => 3, 'type' => 1})
$promotions << Promotion.new({'product' => $products[1], 'new_price' => 200, 'prom_qty' => 2, 'type' => 1})


def buy
	showProductOptions
	choose = gets.chomp
	while(choose != 's')
		choose = choose.to_i
		if choose >= 1 and choose <= $products.length
			puts "Ingrese la cantidad a comprar"
			qty = gets.chomp.to_i
			product_index = choose - 1
			price = calculatePrice($products[product_index], qty)
			puts "El precio es #{price} "
		else
			puts "Opción incorrecta"
		end
		showProductOptions
		choose = gets.chomp
	end
end

def calculatePrice(product, qty)
	if product.productHasPromo?
		promo = getPromo product
		price = calcPromoPrice(promo, product, qty)
		return price
	else
		#units missing
		price = qty * product.price
		return price
	end
end



def getPromo product
	$promotions.each do |promo|
		if(promo.product == product)
			return promo
		end
	end
end

def calcPromoPrice(promo, product, qty)
	promo_price_qty = 0
	regular_price_qty = 0
	if promo.type == 1
		promo_price_qty = (qty / promo.prom_qty).to_i * promo.prom_qty
		regular_price_qty = qty - promo_price_qty
	end
	if promo.type == 2
		puts 'to do'
	end

	final_price = promo_price_qty * promo.new_price + regular_price_qty * product.price
	return final_price
end

def showProductOptions
	puts "\n\n"
	puts "Seleccione el producto a comprar"
	puts "Ingrese el caracter correspondiente a alguna de las opciones"
	showAllProducts
	puts "s. Salir"

end


def showAllProducts
	$products.each_with_index do |product, i|
		puts "#{i+1}. #{product.name}"
	end
end

def showAllPromotions
	$promotions.each_with_index do |promo, i|
		puts "#{i+1}. #{promo.product.name}"
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
			puts 'case2'
		when '3'
			cls
			puts 'case 3'
		when '4'
			cls
		when '5'
			cls
		else
			'Opción incorrecta'
		end
		showMainMenu
		choose = gets.chomp
	end

end

def showMainMenu
	puts "\n\n"
	puts "Seleccione la opción a realizar"
	puts "Ingrese el caracter correspondiente a alguna de las opciones"
	puts "1. Realizar venta"
	puts "2. Agregar Producto"
	puts "3. Eliminar Producto"
	puts "4. Agregar Promoción"
	puts "5. Elimianar Promoción"
	puts "s. Salir"
end

def cls
  system('cls')
end

mainMenu