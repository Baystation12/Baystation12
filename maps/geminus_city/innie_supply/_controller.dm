
/datum/controller/process/innie_factions
	name = "Insurrection Factions Controller"
	var/datum/shuttle/autodock/ferry/geminus_innie/geminus_supply_shuttle
	var/list/requestlist = list()
	var/list/shoppinglist = list()
	var/list/all_exports = list()
	var/list/exports_formatted = list()
	var/innie_credits = 0
	var/export_credits = 0
	var/manifest_value = 5

/datum/controller/process/innie_factions/proc/send_shuttle(var/mob/living/user)
	if(geminus_supply_shuttle.at_station())
		geminus_supply_shuttle.launch(user)

/datum/controller/process/innie_factions/proc/bring_shuttle(var/mob/living/user)
	if(!geminus_supply_shuttle.at_station())
		for(var/datum/supply_order/O in requestlist)
		geminus_supply_shuttle.launch(user)

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/process/innie_factions/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		if(!istype(A,/mob/living/simple_animal))
			return 1
	if(istype(A,/obj/item/weapon/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

/datum/controller/process/innie_factions/proc/shuttle_sell(var/mob/living/carbon/human/H)
	var/list/new_exports = list()
	var/sale_credits = 0
	for(var/area/subarea in geminus_supply_shuttle.shuttle_area)
		//remove any old traders
		for(var/mob/living/simple_animal/W in subarea)
			qdel(W)

		for(var/obj/AM in subarea)
			if(istype(AM, /obj/structure/closet/crate))
				var/obj/structure/closet/crate/C = AM
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
								E.unit_price = manifest_value
							E.quantity += 1
							sale_credits += E.unit_price
				qdel(AM)

	for(var/datum/trade_item/T in new_exports)
		var/datum/supply_export/E = new_exports[T]
		exports_formatted.Add(list(list("name" = T.name, "time" = E.time, "authorised" = "[E.launchedby] ([E.launchedrank])", "unit_price" = E.unit_price, "quantity" = E.quantity)))

	all_exports += new_exports
	innie_credits += sale_credits
	export_credits += sale_credits

/datum/controller/process/innie_factions/proc/shuttle_buy()
	var/list/clear_turfs = list()
	for(var/area/subarea in geminus_supply_shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)	continue
			var/contcount
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				contcount++
			if(contcount)
				continue
			clear_turfs += T

	//spawn a new trader with a selection of stuff
	if(clear_turfs.len)
		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)
		var/mob/living/simple_animal/npc/colonist/weapon_smuggler/W = new(pickedloc)
		W.name = "[W.real_name] (Weapons Trader)"

	for(var/S in shoppinglist)
		if(!clear_turfs.len)	break
		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)
		shoppinglist -= S

		var/datum/supply_order/SO = S
		var/decl/hierarchy/supply_pack/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.name = "[SP.containername][SO.comment ? " ([SO.comment])":"" ]"
		//supply manifest generation begin

		var/obj/item/weapon/paper/manifest/slip
		slip = new /obj/item/weapon/paper/manifest(A)
		slip.name = "Shipping Manifest Order #[SO.ordernum]"
		slip.is_copy = 0
		slip.info = "<h3>Black Market Shipping Manifest</h3><hr><br>"
		slip.info +="Order #[SO.ordernum]<br>"
		slip.info +="Destination: [GLOB.using_map.station_name]<br>"
		slip.info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
		slip.info +="CONTENTS:<br><ul>"

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			if(isnum(SP.access))
				A.req_access = list()
			else if(islist(SP.access))
				var/list/L = SP.access // access var is a plain var, we need a list
				A.req_access = L.Copy()
			else
				log_debug("<span class='danger'>Supply pack with invalid access restriction [SP.access] encountered!</span>")

		var/list/spawned = SP.spawn_contents(A)
		if(slip)
			for(var/atom/content in spawned)
				slip.info += "<li>[content.name]</li>" //add the item to the manifest
			slip.info += "</ul><br>"
			slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
