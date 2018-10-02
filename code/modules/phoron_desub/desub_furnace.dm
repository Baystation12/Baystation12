/*  //////// NEUTRON FURNACE /////////
	Put a supermatter shard inside of it, set neutron flow to specific level, get materials out
*/
/obj/machinery/phoron_desublimer/furnace
	name = "Neutron Furnace"
	desc = "A modern day alchemist's best friend."
	icon_state = "open"

	var/min_neutron_flow = 1
	var/neutron_flow = 30
	var/max_neutron_flow = 350
	var/obj/item/weapon/material/shard/supermatter/shard = null

	var/list/mat = list(MATERIAL_OSMIUM, MATERIAL_PHORON, MATERIAL_DIAMOND, MATERIAL_PLATINUM, MATERIAL_GOLD, MATERIAL_URANIUM,  MATERIAL_SILVER, MATERIAL_STEEL, MATERIAL_SUPERMATTER)
	var/list/mat_mod = list(
		MATERIAL_STEEL = 3.5,
		MATERIAL_SILVER = 1.5,
		MATERIAL_URANIUM = 0.8,
		MATERIAL_GOLD = 1,
		MATERIAL_PLATINUM = 0.7,
		MATERIAL_DIAMOND = 0.55,
		MATERIAL_PHORON = 0.55,
		MATERIAL_OSMIUM = 1,
		MATERIAL_SUPERMATTER = 1.0) // modifier for output amount

	var/list/mat_peak

	var/list/obj/item/stack/material/mat_obj = list(
		MATERIAL_DIAMOND = /obj/item/stack/material/diamond,
		MATERIAL_STEEL = /obj/item/stack/material/steel,
		MATERIAL_SILVER = /obj/item/stack/material/silver,
		MATERIAL_PLATINUM = /obj/item/stack/material/platinum,
		MATERIAL_OSMIUM = /obj/item/stack/material/osmium,
		MATERIAL_GOLD = /obj/item/stack/material/gold,
		MATERIAL_URANIUM = /obj/item/stack/material/uranium,
		MATERIAL_PHORON = /obj/item/stack/material/phoron,
		MATERIAL_SUPERMATTER = /obj/item/weapon/material/shard/supermatter) // cost per each mod # of bars

/obj/machinery/phoron_desublimer/furnace/Initialize()
		. = ..()

		mat_peak = list(
			MATERIAL_STEEL = 30, \
			MATERIAL_SILVER = rand(40, 70), \
			MATERIAL_URANIUM = rand(80, 110), \
			MATERIAL_GOLD = rand(120, 150), \
			MATERIAL_PLATINUM = rand(160, 190), \
			MATERIAL_DIAMOND = rand(200, 230), \
			MATERIAL_PHORON = rand(240, 270), \
			MATERIAL_OSMIUM = rand(280, 300), \
			MATERIAL_SUPERMATTER = rand(310, 340)) // Setting peak locations

		neutron_flow = rand(1,350)

		component_parts = list()
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
		component_parts += new /obj/item/weapon/stock_parts/capacitor(src)

/obj/machinery/phoron_desublimer/furnace/Destroy()
	if(shard)
		shard.dropInto(loc)
		shard = null
	for(var/obj/machinery/computer/phoron_desublimer_control/DC in get_area(src))
		if(DC.furnace)
			DC.furnace = null
			DC.find_parts()
	. = ..()

/obj/machinery/phoron_desublimer/furnace/proc/eject_shard()
	if(!shard)
		return
	if(active)
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"Transmutation in progress, ejection failed.\"")
		return

	shard.dropInto(loc)
	shard = null
	update_icon()

/obj/machinery/phoron_desublimer/furnace/proc/modify_flow(var/change)
	neutron_flow += change
	neutron_flow = Clamp(neutron_flow, 0, max_neutron_flow)

	// Produces the resultant material
/obj/machinery/phoron_desublimer/furnace/proc/produce()
	if(active)
		return
	if(!shard)
		src.visible_message("\icon[src] <b>[src]</b> buzzes, \"Needs a supermatter shard to transmutate.\"")
		return

	active = 1
	playsound(loc, 'sound/effects/neutron_charge.ogg', 50, 1, -1)
	flick("Active", src)
	for(var/mob/living/l in oview(src, round(sqrt(neutron_flow / 2))))
		var/rads = (neutron_flow / 3) * sqrt(1 / get_dist(l, src))
		l.apply_effect(rads, IRRADIATE)
	sleep(28)
	playsound(loc, 'sound/effects/laser_sustained.ogg', 75, 1, -1)
	sleep(8)
	playsound(loc, 'sound/machines/ding.ogg', 50, 1, -1)
	sleep(10)

	var/list/peak_distances = list()
	peak_distances = get_peak_distances(neutron_flow)
	var/max_distance = 5.0 // Max peak distance from neutron flow which will still produce materials

	var/amount = 0
	for(var/cur_mat in peak_distances)
		var/distance = peak_distances[cur_mat]

		if(distance <= max_distance)
			if(cur_mat == "Supermatter")
				new /obj/item/weapon/material/shard/supermatter(get_turf(src), shard.smlevel+1)
				break
			else
				var/size_modifier = shard.size*0.2
				// Produces amount based on distance from flow and modifier
				//amount = ((max_distance-distance)/max_distance)*mat_mod[cur_mat]
				//amount += amount*size_modifier

				var/k = (2 * M_PI) / (max_distance * 4)
				var/sin_exp = (k * M_PI * distance) + (M_PI / 2)

				amount = mat_mod[cur_mat] * size_modifier * sin(ToDegrees(sin_exp))
				amount = round(amount)

				if(amount > 0) // Will only do anything if any amount was actually created
					var/obj/item/stack/material/T = mat_obj[cur_mat]
					new T(loc, amount)

	eat_shard()
	src.visible_message("\icon[src] <b>[src]</b> beeps, \"Supermatter transmutation complete.\"")
	active = 0

	// This sorts a list of peaks within max_distance units of the given flow and returns a sorted list of the nearest ones
/obj/machinery/phoron_desublimer/furnace/proc/get_peak_distances(var/flow)
	var/list/peak_distances = new/list()

	for(var/cur_mat in mat_peak)
		var/peak = mat_peak[cur_mat]
		var/peak_distance = abs(peak-flow)
		peak_distances[cur_mat] = peak_distance

	return peak_distances

	// Eats the shard, duh
/obj/machinery/phoron_desublimer/furnace/proc/eat_shard()
	if(!shard)
		return 0

	QDEL_NULL(shard)

	update_icon()
	return 1

/obj/machinery/phoron_desublimer/furnace/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	if(isrobot(user))
		return
	if(istype(B, /obj/item/weapon/material/shard/supermatter))
		if(!shard)
			if(!user.unequip_item(src))
				return
			shard = B
			to_chat(user, "You put [B] into the machine.")
		else
			to_chat(user, "There is already a shard in the machine.")
	else
		to_chat(user, "<span class='notice'>This machine only accepts supermatter shards</span>")

	update_icon()


/obj/machinery/phoron_desublimer/furnace/on_update_icon()
	if(shard)
		icon_state = "opencrystal"
	else
		icon_state = "open"