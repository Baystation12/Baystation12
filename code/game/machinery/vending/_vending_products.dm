/datum/stored_items/vending_products
	var/price
	var/display_color
	var/category
	var/rarity


/datum/stored_items/vending_products/New(atom/vending_machine, path, name, amount, price, color, category, rarity)
	..()
	price = price
	display_color = color
	category = category
	rarity = rarity
