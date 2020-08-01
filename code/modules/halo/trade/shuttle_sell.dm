
/datum/shuttle/autodock/ferry/trade/proc/shuttle_sell(var/mob/living/carbon/human/H)
	//override me
	//src.money_account
	/*
	var/datum/money_account/D = get_account(attempt_account_number)
	if(!D || D.suspended)
		return 0
	D.money = max(0, D.money + amount)

	//create a transaction log entry
	var/datum/transaction/T = new(source_name, purpose, amount, terminal_id)
	D.transaction_log.Add(T)
	*/

	var/list/new_exports = list()
	var/sale_credits = 0
	for(var/area/subarea in shuttle_area)
		//remove any old traders
		for(var/mob/living/simple_animal/W in subarea)
			qdel(W)

		for(var/obj/AM in subarea)
			if(istype(AM, /obj/structure/closet))
				var/obj/structure/closet/C = AM
				for(var/obj/O in C)
					if(O.type in GLOB.trade_controller.trade_items_by_type)
						var/datum/trade_item/T = GLOB.trade_controller.trade_items_by_type[O.type]
						var/datum/supply_export/E = new_exports[T]
						if(!E)
							E = new()
							new_exports[T] = E
							//
							E.time = stationtime2text()
							E.launchedby = H.get_authentification_name()
							E.launchedrank = H.get_assignment()
							E.unit_price = T.value
						E.quantity += 1
						sale_credits += E.unit_price
					else if(istype(O,/obj/item/weapon/paper/manifest))
						var/obj/item/weapon/paper/manifest/slip = O
						if(!slip.is_copy && slip.stamped && slip.stamped.len) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
							var/datum/supply_export/E = new_exports["Supply Manifest"]
							if(!E)
								E = new()
								new_exports["Supply Manifest"] = E
								//
								E.time = stationtime2text()
								E.launchedby = H.get_authentification_name()
								E.launchedrank = H.get_assignment()
								E.unit_price = 5
							E.quantity += 1
							sale_credits += E.unit_price
				qdel(AM)

	for(var/datum/trade_item/T in new_exports)
		var/datum/supply_export/E = new_exports[T]
		exports_formatted.Add(list(list("name" = T.name, "time" = E.time, "authorised" = "[E.launchedby] ([E.launchedrank])", "unit_price" = E.unit_price, "quantity" = E.quantity)))

	all_exports += new_exports
	export_credits += sale_credits
	//
	var/datum/transaction/T = new("Trade Market", "[src.name] export goods", sale_credits, "System Terminal #G[rand(100000,999999)]")
	money_account.transaction_log.Add(T)
	money_account.money += sale_credits
