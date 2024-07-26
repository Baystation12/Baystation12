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
		"anomaly" = "From scanned and categorized anomalies",
		"animal" = "From captured exotic alien fauna",
		"total" = "Total" // If you're adding additional point sources, add it here in a new line. Don't forget to put a comma after the old last line.
	)

/datum/controller/subsystem/supply/Initialize(start_uptime)
	ordernum = rand(1,9000)

	//Build master supply list
	var/singleton/hierarchy/supply_pack/root = GET_SINGLETON(/singleton/hierarchy/supply_pack)
	for (var/singleton/hierarchy/supply_pack/sp in root.children)
		if(sp.is_category())
			for(var/singleton/hierarchy/supply_pack/spc in sp.get_descendents())
				spc.setup()
				master_supply_list += spc

	for (var/material/mat in SSmaterials.materials)
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
	if (istype(A, /mob/living))
		var/mob/living/mob = A
		if (istype(mob, /mob/living/simple_animal/hostile/human) || mob.mind)
			return TRUE
	if (istype(A, /obj/item/disk/nuclear))
		return TRUE
	if (istype(A, /obj/machinery/nuclearbomb))
		return TRUE
	if (istype(A, /obj/machinery/tele_beacon))
		return TRUE

	for(var/i=1, i<=length(A.contents), i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return TRUE

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
						if(!slip.is_copy && slip.stamped && length(slip.stamped)) //Any stamp works.
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
						add_points_from_source(round(D.Value() * 0.05), "gep")

			// Sell artefacts (in anomaly cages)
			if (istype(AM, /obj/machinery/anomaly_container))
				var/obj/machinery/anomaly_container/AC = AM
				var/points_per_anomaly = 10
				callHook("sell_anomalycage", list(AC, subarea))
				if (AC.contained)
					var/obj/machinery/artifact/C = AC.contained
					var/list/my_effects = list()
					if (C.my_effect)
						var/datum/artifact_effect/eone = C.my_effect
						my_effects += eone
					if (C.secondary_effect)
						var/datum/artifact_effect/etwo = C.secondary_effect
						my_effects += etwo
					//Different effects and trigger combos give different rewards

					if (AC.attached_paper) //Needs to have a scan sheet of the anomaly to the container.
						if (istype(AC.attached_paper, /obj/item/paper/anomaly_scan))
							var/obj/item/paper/anomaly_scan/P = AC.attached_paper
							if (!P.is_copy)
								for (var/datum/artifact_effect/E in my_effects)
									switch (E.effect_type)
										if (EFFECT_UNKNOWN, EFFECT_PSIONIC)
											points_per_anomaly += 10
										if (EFFECT_ENERGY, EFFECT_ELECTRO)
											points_per_anomaly += 20
										if (EFFECT_ORGANIC, EFFECT_SYNTH)
											points_per_anomaly += 30
										if (EFFECT_BLUESPACE, EFFECT_PARTICLE)
											points_per_anomaly += 40
										else
											points_per_anomaly += 10
											//In case there's ever a broken artifact, it's still worth SOMETHING
									switch (E.trigger.trigger_type)
										if (TRIGGER_SIMPLE)
											points_per_anomaly += 5
										if (TRIGGER_COMPLEX)
											points_per_anomaly += 10
										else
											points_per_anomaly += 2

								add_points_from_source(points_per_anomaly, "anomaly")

			//Only for animals in stasis cages.
			if (istype(AM, /obj/machinery/stasis_cage))
				var/obj/machinery/stasis_cage/SC = AM
				var/points_per_animal = 10
				callHook("sell_animal", list(SC, subarea))
				if (SC.contained)
					var/mob/living/simple_animal/CA = SC.contained
					if (istype(CA, /mob/living/simple_animal/hostile/human))
						continue
					if (istype(CA, /mob/living/simple_animal/hostile))
						points_per_animal *= 2
					if (istype(CA, /mob/living/simple_animal/hostile/retaliate/beast))
						points_per_animal *= 2
					if (CA.stat != DEAD) //Alive gives more.
						points_per_animal *= 2

					qdel(SC.contained)
					add_points_from_source(points_per_animal, "animal")

			qdel(AM)

	if(length(material_count))
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
	if(!length(shoppinglist))
		return

	var/list/clear_turfs = get_clear_turfs()

	for(var/S in shoppinglist)
		if(!length(clear_turfs))
			break
		var/turf/pickedloc = pick_n_take(clear_turfs)
		shoppinglist -= S
		donelist += S

		var/datum/supply_order/SO = S
		var/singleton/hierarchy/supply_pack/SP = SO.object

		var/obj/A = new SP.containertype(pickedloc)
		A.SetName("[SP.containername][SO.comment ? " ([SO.comment])":"" ]")
		//supply manifest generation begin

		var/obj/item/paper/manifest/slip
		if(!SP.contraband)
			var/info = list()
			info +="<h3>[GLOB.using_map.boss_name] Shipping Manifest</h3><hr><br>"
			info +="Order #[SO.ordernum]<br>"
			info +="Destination: [GLOB.using_map.station_name]<br>"
			info +="[length(shoppinglist)] PACKAGES IN THIS SHIPMENT<br>"
			info +="CONTENTS:<br><ul>"

			slip = new /obj/item/paper/manifest(A, JOINTEXT(info))
			slip.is_copy = FALSE

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
/datum/controller/subsystem/supply/proc/addAtom(atom/movable/A)
	var/list/clear_turfs = get_clear_turfs()
	if(!length(clear_turfs))
		return FALSE

	var/turf/pickedloc = pick(clear_turfs)

	A.forceMove(pickedloc)

	return TRUE

/datum/supply_order
	var/ordernum
	var/singleton/hierarchy/supply_pack/object = null
	var/orderedby = null
	var/comment = null
	var/reason = null
	var/orderedrank = null //used for supply console printing
