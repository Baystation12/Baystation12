SUBSYSTEM_DEF(supply)
	name = "Supply"
	wait = 20 SECONDS
	priority = SS_PRIORITY_SUPPLY
	//Initializes at default time
	flags = SS_NO_TICK_CHECK

	//supply points
	var/points = 50
	var/points_per_process = 1
	var/points_per_slip = 2
	var/point_sources = list()
	var/pointstotalsum = 0
	var/pointstotal = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/donelist = list()
	var/list/master_supply_list = list()
	//shuttle movement
	var/movetime = 1200
	var/datum/shuttle/autodock/ferry/supply/shuttle
	var/list/point_source_descriptions = list(
		"time" = "Base station supply",
		"manifest" = "From exported manifests",
		"crate" = "From exported crates",
		"gep" = "From uploaded good explorer points",
		"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
	)

/datum/controller/subsystem/supply/Initialize(start_uptime)
	ordernum = rand(1,9000)

	//Build master supply list
	var/decl/hierarchy/supply_pack/root = decls_repository.get_decl(/decl/hierarchy/supply_pack)
	for(var/decl/hierarchy/supply_pack/sp in root.children)
		if(sp.is_category())
			for(var/decl/hierarchy/supply_pack/spc in sp.get_descendents())
				spc.setup()
				master_supply_list += spc

	for(var/material/mat in SSmaterials.materials)
		if(mat.sale_price > 0)
			point_source_descriptions[mat.display_name] = "From exported [mat.display_name]"

// Just add points over time.
/datum/controller/subsystem/supply/fire()
	add_points_from_source(points_per_process, "time")


/datum/controller/subsystem/supply/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Points: [points]")


//Supply-related helper procs.

/datum/controller/subsystem/supply/proc/add_points_from_source(amount, source)
	points += amount
	point_sources[source] += amount
	point_sources["total"] += amount

	//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/subsystem/supply/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/disk/nuclear))
		return 1
	if(istype(A,/obj/machinery/nuclearbomb))
		return 1
	if(istype(A,/obj/machinery/tele_beacon))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

/datum/controller/subsystem/supply/proc/sell()
	var/list/material_count = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/atom/movable/AM in subarea)
			if(AM.anchored)
				continue
			if(istype(AM, /obj/structure/closet/crate))
				var/obj/structure/closet/crate/CR = AM
				callHook("sell_crate", list(CR, subarea))
				add_points_from_source(CR.points_per_crate, "crate")
				var/find_slip = 1

				for(var/atom in CR)
					// Sell manifests
					var/atom/A = atom
					if(find_slip && istype(A,/obj/item/paper/manifest))
						var/obj/item/paper/manifest/slip = A
						if(!slip.is_copy && slip.stamped && slip.stamped.len) //Any stamp works.
							add_points_from_source(points_per_slip, "manifest")
							find_slip = 0
						continue

					// Sell materials
					if(istype(A, /obj/item/stack/material))
						var/obj/item/stack/material/P = A
						if(P.material && P.material.sale_price > 0)
							material_count[P.material.display_name] += P.get_amount() * P.material.sale_price * P.matter_multiplier
						if(P.reinf_material && P.reinf_material.sale_price > 0)
							material_count[P.reinf_material.display_name] += P.get_amount() * P.reinf_material.sale_price * P.matter_multiplier * 0.5
						continue

					// Must sell ore detector disks in crates
					if(istype(A, /obj/item/disk/survey))
						var/obj/item/disk/survey/D = A
						add_points_from_source(round(D.Value() * 0.005), "gep")

			qdel(AM)

	if(material_count.len)
		for(var/material_type in material_count)
			add_points_from_source(material_count[material_type], material_type)

/datum/controller/subsystem/supply/proc/get_clear_turfs()
	var/list/clear_turfs = list()

	for(var/area/subarea in shuttle.shuttle_area)
		for(var/turf/T in subarea)
			if(T.density)
				continue
			var/occupied = 0
			for(var/atom/A in T.contents)
				if(!A.simulated)
					continue
				occupied = 1
				break
			if(!occupied)
				clear_turfs += T

	return clear_turfs

//Buyin
/datum/controller/subsystem/supply/proc/buy()
	if(!shoppinglist.len)
		return

	var/list/clear_turfs = get_clear_turfs()

	for(var/S in shoppinglist)
		if(!clear_turfs.len)
			break
		var/turf/pickedloc = pick_n_take(clear_turfs)
		shoppinglist -= S
		donelist += S

		var/datum/supply_order/SO = S
		var/decl/hierarchy/supply_pack/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.SetName("[SP.containername][SO.comment ? " ([SO.comment])":"" ]")
		//supply manifest generation begin

		var/obj/item/paper/manifest/slip
		if(!SP.contraband)
			var/info = list()
			info +="<h3>[GLOB.using_map.boss_name] Shipping Manifest</h3><hr><br>"
			info +="Order #[SO.ordernum]<br>"
			info +="Destination: [GLOB.using_map.station_name]<br>"
			info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
			info +="CONTENTS:<br><ul>"

			slip = new /obj/item/paper/manifest(A, JOINTEXT(info))
			slip.is_copy = 0

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			if(!islist(SP.access))
				A.req_access = list(SP.access)
			else if(islist(SP.access))
				var/list/L = SP.access // access var is a plain var, we need a list
				A.req_access = L.Copy()

		var/list/spawned = SP.spawn_contents(A)
		if(slip)
			for(var/atom/content in spawned)
				slip.info += "<li>[content.name]</li>" //add the item to the manifest
			slip.info += "</ul><br>CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"

// Adds any given item to the supply shuttle
/datum/controller/subsystem/supply/proc/addAtom(var/atom/movable/A)
	var/list/clear_turfs = get_clear_turfs()
	if(!clear_turfs.len)
		return FALSE

	var/turf/pickedloc = pick(clear_turfs)

	A.forceMove(pickedloc)

	return TRUE

/datum/supply_order
	var/ordernum
	var/decl/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null
	var/reason = null
	var/orderedrank = null //used for supply console printing
