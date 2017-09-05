/datum/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	O.object = pick(cargo_supply_packs)
	O.orderedby = random_name(pick(MALE,FEMALE), species = SPECIES_HUMAN)
	supply_controller.shoppinglist += O
