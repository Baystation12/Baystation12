//Config stuff
#define SUPPLY_DOCKZ 2          //Z-level of the Dock.
#define SUPPLY_STATIONZ 1       //Z-level of the Station.

//Supply packs are in /code/defines/obj/supplypacks.dm
//Computers are in /code/game/machinery/computer/supply.dm

var/datum/controller/supply/supply_controller = new()

var/list/mechtoys = list(
	/obj/item/toy/prize/ripley,
	/obj/item/toy/prize/fireripley,
	/obj/item/toy/prize/deathripley,
	/obj/item/toy/prize/gygax,
	/obj/item/toy/prize/durand,
	/obj/item/toy/prize/honk,
	/obj/item/toy/prize/marauder,
	/obj/item/toy/prize/seraph,
	/obj/item/toy/prize/mauler,
	/obj/item/toy/prize/odysseus,
	/obj/item/toy/prize/phazon
)

/obj/item/weapon/paper/manifest
	name = "supply manifest"
	var/is_copy = 1

/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper plastic flaps"
	desc = "Completely impassable - or are they?"
	icon = 'icons/obj/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = 0
	anchored = 1
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	explosion_resistance = 5
	var/list/mobs_can_pass = list(
		/mob/living/bot,
		/mob/living/carbon/slime,
		/mob/living/simple_animal/mouse,
		/mob/living/silicon/robot/drone
		)

/obj/structure/plasticflaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASSGLASS))
		return prob(60)

	var/obj/structure/bed/B = A
	if (istype(A, /obj/structure/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	if(istype(A, /obj/vehicle))	//no vehicles
		return 0

	var/mob/living/M = A
	if(istype(M))
		if(M.lying)
			return ..()
		for(var/mob_type in mobs_can_pass)
			if(istype(A, mob_type))
				return ..()
		return issmall(M)

	return ..()

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(50))
				qdel(src)
		if (3)
			if (prob(5))
				qdel(src)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps."

	New() //set the turf below the flaps to block air
		var/turf/T = get_turf(loc)
		if(T)
			T.blocks_air = 1
		..()

	Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor
		var/turf/T = get_turf(loc)
		if(T)
			if(istype(T, /turf/simulated/floor))
				T.blocks_air = 0
		..()

/*
/obj/effect/marker/supplymarker
	icon_state = "X"
	icon = 'icons/misc/mark.dmi'
	name = "X"
	invisibility = 101
	anchored = 1
	opacity = 0
*/

/datum/supply_order
	var/ordernum
	var/decl/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null
	var/reason = null
	var/orderedrank = null //used for supply console printing

var/list/point_source_descriptions = list(
	"time" = "Base station supply",
	"manifest" = "From exported manifests",
	"crate" = "From exported crates",
	"phoron" = "From exported phoron",
	"platinum" = "From exported platinum",
	"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
	)

//Adds the points from different sources together and saves them for the export overview
/datum/controller/supply/proc/add_points_from_source(amount, source)
	points += amount
	point_sources[source] += amount
	point_sources["total"] += amount

/datum/controller/supply
	//supply points
	var/points = 50
	var/points_per_process = 1.5
	var/points_per_slip = 2
	var/points_per_platinum = 5 // 5 points per sheet
	var/points_per_phoron = 5
	var/point_sources = list()
	var/pointstotalsum = 0
	var/pointstotal = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/master_supply_list = list()
	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/autodock/ferry/supply/shuttle

	New()
		ordernum = rand(1,9000)

		//Build master supply list
		for(var/decl/hierarchy/supply_pack/sp in cargo_supply_pack_root.children)
			if(sp.is_category())
				for(var/decl/hierarchy/supply_pack/spc in sp.children)
					master_supply_list += spc


	// Supply shuttle ticker - handles supply point regeneration
	// This is called by the process scheduler every thirty seconds
	proc/process()
		add_points_from_source(points_per_process, "time")

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
	proc/forbidden_atoms_check(atom/A)
		if(istype(A,/mob/living))
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

	//Sellin
	proc/sell()
		var/phoron_count = 0
		var/plat_count = 0
		for(var/atom/movable/MA in shuttle.shuttle_area)
			if(MA.anchored)	continue

			// Must be in a crate!
			if(istype(MA,/obj/structure/closet/crate))
				var/obj/structure/closet/crate/CR = MA
				callHook("sell_crate", list(CR, shuttle.shuttle_area))

				add_points_from_source(CR.points_per_crate, "crate")
				var/find_slip = 1

				for(var/atom in CR)
					// Sell manifests
					var/atom/A = atom
					if(find_slip && istype(A,/obj/item/weapon/paper/manifest))
						var/obj/item/weapon/paper/manifest/slip = A
						if(!slip.is_copy && slip.stamped && slip.stamped.len) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
							add_points_from_source(points_per_slip, "manifest")
							find_slip = 0
						continue

					// Sell phoron and platinum
					if(istype(A, /obj/item/stack))
						var/obj/item/stack/P = A
						switch(P.get_material_name())
							if("phoron") phoron_count += P.get_amount()
							if("platinum") plat_count += P.get_amount()
			qdel(MA)

		if(phoron_count)
			var/temp = phoron_count * points_per_phoron
			add_points_from_source(temp, "phoron")

		if(plat_count)
			var/temp = plat_count * points_per_platinum
			add_points_from_source(temp, "platinum")

	//Buyin
	proc/buy()
		if(!shoppinglist.len) return
		var/list/clear_turfs = list()

		for(var/turf/T in shuttle.shuttle_area)
			if(T.density)	continue
			var/contcount
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				contcount++
			if(contcount)
				continue
			clear_turfs += T
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
			if(!SP.contraband)
				slip = new /obj/item/weapon/paper/manifest(A)
				slip.is_copy = 0
				slip.info = "<h3>[command_name()] Shipping Manifest</h3><hr><br>"
				slip.info +="Order #[SO.ordernum]<br>"
				slip.info +="Destination: [using_map.station_name]<br>"
				slip.info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
				slip.info +="CONTENTS:<br><ul>"

			//spawn the stuff, finish generating the manifest while you're at it
			if(SP.access)
				if(isnum(SP.access))
					A.req_access = list(SP.access)
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

		return
