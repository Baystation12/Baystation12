/datum/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = rand(1, 9000)
	var/randomtimeofday = rand(0, 864000) // 24 hours in deciseconds
	O.timestamp = time2text(randomtimeofday, "hh:mm")
	O.object = pick(SSsupply.master_supply_list)
	O.orderedby = random_name(pick(MALE,FEMALE), species = SPECIES_HUMAN)
	SSsupply.shoppinglist += O
	SSsupply.points = max(0, SSsupply.points - O.object.cost)
