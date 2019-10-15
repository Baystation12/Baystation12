
/datum/shuttle/autodock/ferry/trade/proc/shuttle_buy()
	var/list/clear_turfs = list()
	for(var/area/subarea in shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue
			var/contcount
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				contcount++
			if(contcount)
				continue
			clear_turfs += T

	//spawn a new trader with a selection of stuff
	if(clear_turfs.len && spawn_trader_type)
		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)
		new spawn_trader_type(pickedloc)

	var/datum/transaction/T = new("Geminus System Black market", "Rabbit Hole Base import goods", 0, "Black Market Terminal #B[rand(100000,999999)]")
	money_account.transaction_log.Add(T)

	for(var/S in shoppinglist)
		if(!clear_turfs.len)	break
		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)
		shoppinglist -= S

		var/datum/supply_order/SO = S
		var/decl/hierarchy/supply_pack/SP = SO.object

		var/obj/A
		if(SP.containertype)
			A = new SP.containertype(pickedloc)
			A.name = "[SP.containername][SO.comment ? " ([SO.comment])":"" ]"
		else
			A = pickedloc
		//supply manifest generation begin

		T.amount += SP.cost * CARGO_CRATE_COST_MULTI

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
