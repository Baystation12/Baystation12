/obj/item/device/gps
	name = "relay positioning device"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network."
	icon = 'icons/obj/device.dmi'
	icon_state = "locator"
	item_state = "locator"
	origin_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_ALUMINIUM = 250, MATERIAL_STEEL = 250, MATERIAL_GLASS = 50)
	w_class = ITEM_SIZE_SMALL

/obj/item/device/gps/attack_self(var/mob/user as mob)
	to_chat(user, "<span class='notice'>\icon[src] \The [src] flashes <i>[get_coordinates()]</i>.</span>")

/obj/item/device/gps/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>\The [src]'s screen shows: <i>[get_coordinates()]</i>.</span>")

/obj/item/device/gps/proc/get_coordinates()
	var/turf/T = get_turf(src)
	return T ? "[T.x]:[T.y]:[T.z]" : "N/A"

/mob/living/carbon/human/Stat()
	. = ..()
	if(statpanel("Status"))
		var/obj/item/device/gps/L = locate() in src
		if(L)
			stat("Coordinates:", "[L.get_coordinates()]")

/obj/item/device/measuring_tape
	name = "measuring tape"
	desc = "A coiled metallic tape used to check dimensions and lengths."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "measuring"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_STEEL = 100)
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/storage/bag/fossils
	name = "fossil satchel"
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
		S.SetName("sample bag")
		S.desc = "a bag for holding research samples."

/obj/item/device/ano_scanner
	name = "\improper Alden-Saraspova counter"
	desc = "A device which aids in triangulation of exotic particles."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "flashgun"
	item_state = "lampgreen"
	origin_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	matter = list(MATERIAL_STEEL = 5000, MATERIAL_ALUMINIUM = 5000, MATERIAL_GLASS = 5000)
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

		for(var/A in SSxenoarch.artifact_spawning_turfs)
			var/turf/simulated/mineral/T = A
			if(T.density && T.artifact_find)
				if(T.z == cur_turf.z)
					var/cur_dist = get_dist(cur_turf, T) * 2
					if(nearestTargetDist < 0 || cur_dist < nearestTargetDist)
						nearestTargetDist = cur_dist + rand() * 2 - 1
						nearestTargetId = T.artifact_find.artifact_id
			else
				SSxenoarch.artifact_spawning_turfs.Remove(T)

		for(var/A in SSxenoarch.digsite_spawning_turfs)
			var/turf/simulated/mineral/T = A
			if(T.density && T.finds && T.finds.len)
				if(T.z == cur_turf.z)
					var/cur_dist = get_dist(cur_turf, T) * 2
					if(nearestSimpleTargetDist < 0 || cur_dist < nearestSimpleTargetDist)
						nearestSimpleTargetDist = cur_dist + rand() * 2 - 1
			else
				SSxenoarch.digsite_spawning_turfs.Remove(T)

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
	desc = "A device used to check spatial depth and density of rock outcroppings."
	icon = 'icons/obj/pda.dmi'
	icon_state = "crap"
	item_state = "analyzer"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500, MATERIAL_ALUMINIUM = 150)
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
			D.material = M.mineral ? M.mineral.ore_name : "Rock"

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
	show_browser(user, dat,"window=depth_scanner;size=300x500")
	onclose(user, "depth_scanner")

/obj/item/device/depth_scanner/OnTopic(user, href_list)
	if(href_list["select"])
		var/index = text2num(href_list["select"])
		if(index && index <= positive_locations.len)
			current = positive_locations[index]
		. = TOPIC_REFRESH
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
			QDEL_NULL(current)
		. = TOPIC_REFRESH
	else if(href_list["close"])
		close_browser(user, "window=depth_scanner")
	updateSelfDialog()

//Radio beacon locator
/obj/item/weapon/pinpointer/radio
	name = "locator device"
	desc = "Used to scan and locate signals on a particular frequency."
	var/tracking_freq = PUB_FREQ
	matter = list(MATERIAL_ALUMINIUM = 1000, MATERIAL_GLASS = 500)

/obj/item/weapon/pinpointer/radio/acquire_target()
	var/turf/T = get_turf(src)
	var/zlevels = GetConnectedZlevels(T.z)
	var/cur_dist = world.maxx+world.maxy
	for(var/obj/item/device/radio/beacon/R in world)
		if(!R.functioning)
			continue
		if((R.z in zlevels) && R.frequency == tracking_freq)
			var/check_dist = get_dist(src,R)
			if(check_dist < cur_dist)
				cur_dist = check_dist
				. = weakref(R)

/obj/item/weapon/pinpointer/radio/attack_self(var/mob/user as mob)
	interact(user)

/obj/item/weapon/pinpointer/radio/interact(var/mob/user)
	var/dat = "<b>Radio frequency tracker</b><br>"
	dat += {"
				Tracking: <A href='byond://?src=\ref[src];toggle=1'>[active ? "Enabled" : "Disabled"]</A><BR>
				<A href='byond://?src=\ref[src];reset_tracking=1'>Reset tracker</A><BR>
				Frequency:
				<A href='byond://?src=\ref[src];freq=-10'>-</A>
				<A href='byond://?src=\ref[src];freq=-2'>-</A>
				[format_frequency(tracking_freq)]
				<A href='byond://?src=\ref[src];freq=2'>+</A>
				<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
				"}
	show_browser(user, dat,"window=locater;size=300x150")
	onclose(user, "locater")

/obj/item/weapon/pinpointer/radio/OnTopic(user, href_list)
	if(href_list["toggle"])
		toggle(user)
		. = TOPIC_REFRESH

	if(href_list["reset_tracking"])
		target = acquire_target()
		. = TOPIC_REFRESH

	else if(href_list["freq"])
		var/new_frequency = (tracking_freq + text2num(href_list["freq"]))
		if (new_frequency < 1200 || new_frequency > 1600)
			new_frequency = sanitize_frequency(new_frequency, 1499)
		tracking_freq = new_frequency
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)