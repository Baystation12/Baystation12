/datum/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	O.object = supply_controller.supply_packs[pick(supply_controller.supply_packs)]
	O.orderedby = random_name(pick(MALE,FEMALE), species = "Human")
	supply_controller.shoppinglist += O