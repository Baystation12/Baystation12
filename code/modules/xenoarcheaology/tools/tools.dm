/obj/item/device/gps
	name = "relay positioning device"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	item_state = "locator"
	origin_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	w_class = ITEM_SIZE_SMALL

/obj/item/device/gps/attack_self(var/mob/user as mob)
	var/turf/T = get_turf(src)
	to_chat(user, "<span class='notice'>\icon[src] \The [src] flashes <i>[T.x]:[T.y]:[T.z]</i>.</span>")

/obj/item/device/measuring_tape
	name = "measuring tape"
	desc = "A coiled metallic tape used to check dimensions and lengths."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "measuring"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 100)
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/storage/bag/fossils
	name = "Fossil Satchel"
	desc = "Transports delicate fossils in suspension so they don't break during transit."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = ITEM_SIZE_NORMAL
	storage_slots = 50
	max_storage_space = 200
	max_w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/weapon/fossil)

/obj/item/weapon/storage/box/samplebags
	name = "sample bag box"
	desc = "A box claiming to contain sample bags."

/obj/item/weapon/storage/box/samplebags/New()
	..()
	for(var/i = 1 to 7)
		var/obj/item/weapon/evidencebag/S = new(src)
		S.name = "sample bag"
		S.desc = "a bag for holding research samples."

/obj/item/device/ano_scanner
	name = "Alden-Saraspova counter"
	desc = "Aids in triangulation of exotic particles."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "flashgun"
	item_state = "lampgreen"
	origin_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 10000,"glass" = 5000)
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT

	var/last_scan_time = 0
	var/scan_delay = 25

/obj/item/device/ano_scanner/attack_self(var/mob/living/user)
	interact(user)

/obj/item/device/ano_scanner/interact(var/mob/living/user)
	if(world.time - last_scan_time >= scan_delay)
		last_scan_time = world.time

		var/nearestTargetDist = -1
		var/nearestTargetId

		var/nearestSimpleTargetDist = -1
		var/turf/cur_turf = get_turf(src)

		if(master_controller) //Sanity check due to runtimes ~Z
			for(var/A in master_controller.artifact_spawning_turfs)
				var/turf/simulated/mineral/T = A
				if(T.density && T.artifact_find)
					if(T.z == cur_turf.z)
						var/cur_dist = get_dist(cur_turf, T) * 2
						if(nearestTargetDist < 0 || cur_dist < nearestTargetDist)
							nearestTargetDist = cur_dist + rand() * 2 - 1
							nearestTargetId = T.artifact_find.artifact_id
				else
					master_controller.artifact_spawning_turfs.Remove(T)

			for(var/A in master_controller.digsite_spawning_turfs)
				var/turf/simulated/mineral/T = A
				if(T.density && T.finds && T.finds.len)
					if(T.z == cur_turf.z)
						var/cur_dist = get_dist(cur_turf, T) * 2
						if(nearestSimpleTargetDist < 0 || cur_dist < nearestSimpleTargetDist)
							nearestSimpleTargetDist = cur_dist + rand() * 2 - 1
				else
					master_controller.digsite_spawning_turfs.Remove(T)

		if(nearestTargetDist >= 0)
			to_chat(user, "Exotic energy detected on wavelength '[nearestTargetId]' in a radius of [nearestTargetDist]m[nearestSimpleTargetDist > 0 ? "; small anomaly detected in a radius of [nearestSimpleTargetDist]m" : ""]")
		else if(nearestSimpleTargetDist >= 0)
			to_chat(user, "Small anomaly detected in a radius of [nearestSimpleTargetDist]m.")
		else
			to_chat(user, "Background radiation levels detected.")
	else
		to_chat(user, "Scanning array is recharging.")

/obj/item/device/depth_scanner
	name = "depth analysis scanner"
	desc = "Used to check spatial depth and density of rock outcroppings."
	icon = 'icons/obj/pda.dmi'
	icon_state = "crap"
	item_state = "analyzer"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 1000)
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	var/list/positive_locations = list()
	var/datum/depth_scan/current

/datum/depth_scan
	var/time = ""
	var/coords = ""
	var/depth = ""
	var/clearance = 0
	var/record_index = 1
	var/dissonance_spread = 1
	var/material = "unknown"

/obj/item/device/depth_scanner/proc/scan_atom(var/mob/user, var/atom/A)
	user.visible_message("<span class='notice'>\The [user] scans \the [A], the air around them humming gently.</span>")

	if(istype(A, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = A
		if((M.finds && M.finds.len) || M.artifact_find)

			//create a new scanlog entry
			var/datum/depth_scan/D = new()
			D.coords = "[M.x]:[M.y]:[M.z]"
			D.time = stationtime2text()
			D.record_index = positive_locations.len + 1
			D.material = M.mineral ? M.mineral.display_name : "Rock"

			//find the first artifact and store it
			if(M.finds.len)
				var/datum/find/F = M.finds[1]
				D.depth = "[F.excavation_required - F.clearance_range] - [F.excavation_required]"
				D.clearance = F.clearance_range
				D.material = get_responsive_reagent(F.find_type)

			positive_locations.Add(D)

			to_chat(user, "<span class='notice'>\icon[src] [src] pings.</span>")

	else if(istype(A, /obj/structure/boulder))
		var/obj/structure/boulder/B = A
		if(B.artifact_find)
			//create a new scanlog entry
			var/datum/depth_scan/D = new()
			D.coords = "[B.x]:[B.y]:[B.z]"
			D.time = stationtime2text()
			D.record_index = positive_locations.len + 1

			//these values are arbitrary
			D.depth = rand(150, 200)
			D.clearance = rand(10, 50)
			D.dissonance_spread = rand(750, 2500) / 100

			positive_locations.Add(D)

			to_chat(user, "<span class='notice'>\icon[src] [src] pings [pick("madly","wildly","excitedly","crazily")]!</span>")

/obj/item/device/depth_scanner/attack_self(var/mob/living/user)
	interact(user)

/obj/item/device/depth_scanner/interact(var/mob/user as mob)
	var/dat = "<b>Coordinates with positive matches</b><br>"

	dat += "<A href='?src=\ref[src];clear=0'>== Clear all ==</a><br>"

	if(current)
		dat += "Time: [current.time]<br>"
		dat += "Coords: [current.coords]<br>"
		dat += "Anomaly depth: [current.depth] cm<br>"
		dat += "Anomaly size: [current.clearance] cm<br>"
		dat += "Dissonance spread: [current.dissonance_spread]<br>"
		var/index = responsive_carriers.Find(current.material)
		if(index > 0 && index <= finds_as_strings.len)
			dat += "Anomaly material: [finds_as_strings[index]]<br>"
		else
			dat += "Anomaly material: Unknown<br>"
		dat += "<A href='?src=\ref[src];clear=[current.record_index]'>clear entry</a><br>"
	else
		dat += "Select an entry from the list<br>"
		dat += "<br><br><br><br>"
	dat += "<hr>"
	if(positive_locations.len)
		for(var/index = 1 to positive_locations.len)
			var/datum/depth_scan/D = positive_locations[index]
			dat += "<A href='?src=\ref[src];select=[index]'>[D.time], coords: [D.coords]</a><br>"
	else
		dat += "No entries recorded."

	dat += "<hr>"
	dat += "<A href='?src=\ref[src];refresh=1'>Refresh</a><br>"
	dat += "<A href='?src=\ref[src];close=1'>Close</a><br>"
	user << browse(dat,"window=depth_scanner;size=300x500")
	onclose(user, "depth_scanner")

/obj/item/device/depth_scanner/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)

	if(href_list["select"])
		var/index = text2num(href_list["select"])
		if(index && index <= positive_locations.len)
			current = positive_locations[index]
	else if(href_list["clear"])
		var/index = text2num(href_list["clear"])
		if(index)
			if(index <= positive_locations.len)
				var/datum/depth_scan/D = positive_locations[index]
				positive_locations.Remove(D)
				qdel(D)
		else
			//GC will hopefully pick them up before too long
			positive_locations = list()
			qdel(current)
	else if(href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=depth_scanner")

	updateSelfDialog()

/obj/item/device/beacon_locator
	name = "locater device"
	desc = "Used to scan and locate signals on a particular frequency."
	icon = 'icons/obj/device.dmi'
	icon_state = "pinoff"	//pinonfar, pinonmedium, pinonclose, pinondirect, pinonnull
	item_state = "electronic"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 500)
	var/frequency = PUB_FREQ
	var/scan_ticks = 0
	var/obj/item/device/radio/target_radio

/obj/item/device/beacon_locator/New()
	..()
	processing_objects.Add(src)

/obj/item/device/beacon_locator/Destroy()
	processing_objects.Remove(src)
	return ..()

/obj/item/device/beacon_locator/process()
	if(target_radio)
		set_dir(get_dir(src,target_radio))
		switch(get_dist(src,target_radio))
			if(0 to 3)
				icon_state = "pinondirect"
			if(4 to 10)
				icon_state = "pinonclose"
			if(11 to 30)
				icon_state = "pinonmedium"
			if(31 to INFINITY)
				icon_state = "pinonfar"
	else
		if(scan_ticks)
			icon_state = "pinonnull"
			scan_ticks++
			if(prob(scan_ticks * 10))
				spawn(0)
					set background = 1
					if(processing_objects.Find(src))
						//scan radios in the world to try and find one
						var/cur_dist = 999
						for(var/obj/item/device/radio/beacon/R in world)
							if(R.z == src.z && R.frequency == src.frequency)
								var/check_dist = get_dist(src,R)
								if(check_dist < cur_dist)
									cur_dist = check_dist
									target_radio = R

						scan_ticks = 0
						var/turf/T = get_turf(src)
						if(target_radio)
							T.visible_message("\icon[src] [src] [pick("chirps","chirrups","cheeps")] happily.")
						else
							T.visible_message("\icon[src] [src] [pick("chirps","chirrups","cheeps")] sadly.")
		else
			icon_state = "pinoff"

/obj/item/device/beacon_locator/attack_self(var/mob/user as mob)
	return src.interact(user)

/obj/item/device/beacon_locator/interact(var/mob/user as mob)
	var/dat = "<b>Radio frequency tracker</b><br>"
	dat += {"
				<A href='byond://?src=\ref[src];reset_tracking=1'>Reset tracker</A><BR>
				Frequency:
				<A href='byond://?src=\ref[src];freq=-10'>-</A>
				<A href='byond://?src=\ref[src];freq=-2'>-</A>
				[format_frequency(frequency)]
				<A href='byond://?src=\ref[src];freq=2'>+</A>
				<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
				"}

	dat += "<A href='?src=\ref[src];close=1'>Close</a><br>"
	user << browse(dat,"window=locater;size=300x150")
	onclose(user, "locater")

/obj/item/device/beacon_locator/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)

	if(href_list["reset_tracking"])
		scan_ticks = 1
		target_radio = null
	else if(href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if (frequency < 1200 || frequency > 1600)
			new_frequency = sanitize_frequency(new_frequency, 1499)
		frequency = new_frequency

	else if(href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=locater")

	updateSelfDialog()
