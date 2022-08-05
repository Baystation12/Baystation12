/obj/machinery/mining
	icon = 'icons/obj/mining_drill.dmi'
	anchored = FALSE
	use_power = POWER_USE_OFF //The drill takes power directly from a cell.
	density = TRUE
	layer = ABOVE_HUMAN_LAYER //So it draws over mobs in the tile north of it.
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

/obj/machinery/mining/drill
	name = "mining drill head"
	desc = "An enormous drill."
	icon_state = "mining_drill"
	power_channel = LOCAL
	active_power_usage = 10 KILOWATTS
	base_type = /obj/machinery/mining/drill
	machine_name = "mining drill"
	machine_desc = "A cell-powered industrial drill, used to crack through dirt and rock to harvest minerals beneath the surface. Requires two adjacent braces to operate."
	var/braces_needed = 2
	var/list/supports = list()
	var/supported = 0
	var/active = FALSE
	var/list/resource_field = list()

	var/ore_types = list(
		MATERIAL_IRON     = /obj/item/ore/iron,
		MATERIAL_URANIUM =  /obj/item/ore/uranium,
		MATERIAL_GOLD =     /obj/item/ore/gold,
		MATERIAL_SILVER =   /obj/item/ore/silver,
		MATERIAL_DIAMOND =  /obj/item/ore/diamond,
		MATERIAL_PHORON =   /obj/item/ore/phoron,
		MATERIAL_OSMIUM =   /obj/item/ore/osmium,
		MATERIAL_HYDROGEN = /obj/item/ore/hydrogen,
		MATERIAL_SAND =     /obj/item/ore/glass,
		MATERIAL_GRAPHITE = /obj/item/ore/coal,
		MATERIAL_ALUMINIUM = /obj/item/ore/aluminium,
		MATERIAL_RUTILE = /obj/item/ore/rutile
		)

	//Upgrades
	var/harvest_speed
	var/capacity

	//Flags
	var/need_update_field = 0
	var/need_player_check = 0

/obj/machinery/mining/drill/Process()
	if(need_player_check)
		return

	check_supports()

	if(!active) return

	if(!anchored)
		system_error("system configuration error")
		return

	if(stat & NOPOWER)
		system_error("insufficient charge")
		return

	if(need_update_field)
		get_resource_field()

	if(world.time % 10 == 0)
		update_icon()

	if(!active)
		return

	//Drill through the flooring, if any.
	if(istype(get_turf(src), /turf/simulated/floor/asteroid))
		var/turf/simulated/floor/asteroid/T = get_turf(src)
		if(!T.dug)
			T.gets_dug()
	else if(istype(get_turf(src), /turf/simulated/floor/exoplanet))
		var/turf/simulated/floor/exoplanet/T = get_turf(src)
		if(T.diggable)
			new /obj/structure/pit(T)
			T.diggable = 0
	else if(istype(get_turf(src), /turf/simulated/floor))
		var/turf/simulated/floor/T = get_turf(src)
		T.ex_act(EX_ACT_HEAVY)

	//Dig out the tasty ores.
	if(resource_field.len)
		var/turf/simulated/harvesting = pick(resource_field)

		while(resource_field.len && !harvesting.resources)
			harvesting.has_resources = 0
			harvesting.resources = null
			resource_field -= harvesting
			if(resource_field.len)
				harvesting = pick(resource_field)

		if(!harvesting || !harvesting.resources)
			return

		var/total_harvest = harvest_speed //Ore harvest-per-tick.
		var/found_resource = 0 //If this doesn't get set, the area is depleted and the drill errors out.

		for(var/metal in ore_types)

			if(contents.len >= capacity)
				system_error("insufficient storage space")
				set_active(FALSE)
				need_player_check = 1
				update_icon()
				return

			if(contents.len + total_harvest >= capacity)
				total_harvest = capacity - contents.len

			if(total_harvest <= 0) break
			if(harvesting.resources[metal])

				found_resource  = 1

				var/create_ore = 0
				if(harvesting.resources[metal] >= total_harvest)
					harvesting.resources[metal] -= total_harvest
					create_ore = total_harvest
					total_harvest = 0
				else
					total_harvest -= harvesting.resources[metal]
					create_ore = harvesting.resources[metal]
					harvesting.resources[metal] = 0

				for(var/i=1, i <= create_ore, i++)
					var/oretype = ore_types[metal]
					new oretype(src)

		if(!found_resource)
			harvesting.has_resources = 0
			harvesting.resources = null
			resource_field -= harvesting
	else
		set_active(FALSE)
		need_player_check = 1
		update_icon()

/obj/machinery/mining/drill/proc/set_active(var/new_active)
	if(active != new_active)
		active = new_active
		update_use_power(active ? POWER_USE_ACTIVE : POWER_USE_OFF)

/obj/machinery/mining/drill/cannot_transition_to(state_path)
	if(active)
		return SPAN_NOTICE("You must turn \the [src] off first.")
	return ..()

/obj/machinery/mining/drill/components_are_accessible(path)
	return !active && ..()

/obj/machinery/mining/drill/physical_attack_hand(mob/user as mob)
	check_supports()
	if(need_player_check)
		if(can_use_power_oneoff(10 KILOWATTS))
			system_error("insufficient charge")
		else if(anchored)
			get_resource_field()
		to_chat(user, "You hit the manual override and reset the drill's error checking.")
		need_player_check = 0
		update_icon()
		return TRUE
	if(supported && !panel_open)
		if(!(stat & NOPOWER))
			set_active(!active)
			if(active)
				visible_message("<span class='notice'>\The [src] lurches downwards, grinding noisily.</span>")
				need_update_field = 1
			else
				visible_message("<span class='notice'>\The [src] shudders to a grinding halt.</span>")
		else
			to_chat(user, "<span class='notice'>The drill is unpowered.</span>")
	else
		to_chat(user, "<span class='notice'>Turning on a piece of industrial machinery without sufficient bracing or wires exposed is a bad idea.</span>")

	update_icon()
	return TRUE

/obj/machinery/mining/drill/on_update_icon()
	if(need_player_check)
		icon_state = "mining_drill_error"
	else if(active)
		var/status = clamp(round( (contents.len / capacity) * 4 ), 0, 3)
		icon_state = "mining_drill_active[status]"
	else if(supported)
		icon_state = "mining_drill_braced"
	else
		icon_state = "mining_drill"
	return

/obj/machinery/mining/drill/RefreshParts()
	..()
	harvest_speed = clamp(total_component_rating_of_type(/obj/item/stock_parts/micro_laser), 0, 10)
	capacity = 200 * clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 10)
	var/charge_multiplier = clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 0.1, 10)
	change_power_consumption(initial(active_power_usage) / charge_multiplier, POWER_USE_ACTIVE)

/obj/machinery/mining/drill/proc/check_supports()

	supported = 0

	if((!supports || !supports.len) && initial(anchored) == 0)
		anchored = FALSE
		set_active(FALSE)
	else
		anchored = TRUE

	if(supports && supports.len >= braces_needed)
		supported = 1

	update_icon()

/obj/machinery/mining/drill/proc/system_error(var/error)

	if(error)
		src.visible_message("<span class='notice'>\The [src] flashes a '[error]' warning.</span>")
	need_player_check = 1
	set_active(FALSE)
	update_icon()

/obj/machinery/mining/drill/proc/get_resource_field()
	resource_field = list()
	need_update_field = 0

	for (var/turf/simulated/T in range(2, src))
		if (T.has_resources)
			resource_field += T

	if (!length(resource_field))
		system_error("resources depleted")

/obj/machinery/mining/drill/verb/unload()
	set name = "Unload Drill"
	set category = "Object"
	set src in oview(1)

	if(usr.stat) return

	var/obj/structure/ore_box/B = locate() in orange(1)
	if(B)
		for(var/obj/item/ore/O in contents)
			O.forceMove(B)
		to_chat(usr, "<span class='notice'>You unload the drill's storage cache into the ore box.</span>")
	else
		to_chat(usr, "<span class='notice'>You must move an ore box up to the drill before you can unload it.</span>")


/obj/machinery/mining/brace
	name = "mining drill brace"
	desc = "A machinery brace for an industrial drill. It looks easily two feet thick."
	icon_state = "mining_brace"
	obj_flags = OBJ_FLAG_ROTATABLE
	interact_offline = 1

	machine_name = "mining drill brace"
	machine_desc = "A mobile support strut that provides support for the head of a mining drill when anchored. Placed on either side of the drill head."

	var/obj/machinery/mining/drill/connected

/obj/machinery/mining/brace/cannot_transition_to(state_path)
	if(connected && connected.active)
		return SPAN_NOTICE("You can't work with the brace of a running drill!")
	return ..()

/obj/machinery/mining/brace/attackby(obj/item/W as obj, mob/user as mob)
	if(connected && connected.active)
		to_chat(user, "<span class='notice'>You can't work with the brace of a running drill!</span>")
		return TRUE
	if(component_attackby(W, user))
		return TRUE
	if(isWrench(W))

		if(istype(get_turf(src), /turf/space))
			to_chat(user, "<span class='notice'>You can't anchor something to empty space. Idiot.</span>")
			return

		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "un" : ""]anchor the brace.</span>")

		anchored = !anchored
		if(anchored)
			connect()
		else
			disconnect()

/obj/machinery/mining/brace/proc/connect()

	var/turf/T = get_step(get_turf(src), src.dir)

	for(var/thing in T.contents)
		if(istype(thing, /obj/machinery/mining/drill))
			connected = thing
			break

	if(!connected)
		return

	if(!connected.supports)
		connected.supports = list()

	icon_state = "mining_brace_active"

	connected.supports += src
	connected.check_supports()

/obj/machinery/mining/brace/proc/disconnect()

	if(!connected) return

	if(!connected.supports) connected.supports = list()

	icon_state = "mining_brace"

	connected.supports -= src
	connected.check_supports()
	connected = null

/obj/machinery/mining/brace/dismantle()
	if(connected)
		disconnect()
	..()
