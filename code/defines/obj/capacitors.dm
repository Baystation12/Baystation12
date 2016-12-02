/obj/item/weapon/stock_parts/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	origin_tech = list(TECH_POWER = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50,"glass" = 50)
	var/charge = 0
	var/max_charge = 1000

/obj/item/weapon/stock_parts/capacitor/initialize()
	. = ..()
	max_charge *= rating

/obj/item/weapon/stock_parts/capacitor/proc/charge(var/amount)
	charge += amount
	if(charge > max_charge)
		charge = max_charge

/obj/item/weapon/stock_parts/capacitor/proc/use(var/amount)
	if(charge)
		charge -= amount
		if(charge < 0)
			charge = 0

/obj/item/weapon/stock_parts/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	origin_tech = list(TECH_POWER = 3)
	rating = 2

/obj/item/weapon/stock_parts/capacitor/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	rating = 3
