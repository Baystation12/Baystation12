/datum/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = SSsupply.ordernum
	O.object = pick(cargo_supply_packs)
	O.orderedby = random_name(pick(MALE,FEMALE), species = SPECIES_HUMAN)
	SSsupply.shoppinglist += O
