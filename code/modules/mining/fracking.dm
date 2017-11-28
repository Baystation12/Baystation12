/obj/machinery/fracking
	name = "hydraulic extractor"
	desc = "A well head for extracting natural gases, this one seems to have a built-in hydraulic fracturing device."
	icon = 'icons/obj/mining_drill.dmi'
	icon_state = "mining_drill"
	anchored = 0
	use_power = 0 //The extractor takes power directly from a cell.
	density = 1
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER //So it draws over mobs in the tile north of it.

	var/base_power_usage = 5 KILOWATTS // Base power usage when the extractor is running.
	var/actual_power_usage = 5 KILOWATTS // Actual power usage, with upgrades in mind.
	var/active = 0
	var/list/gas_field = list()

	var/gas_types = list(
		"Oxygen" = "oxygen",
		"N2" = "nitrogen",
		"CO2" = "carbon_dioxide",
		"Pr" = "phoron",
		"N2O" = "sleeping_agent",
		"CH4" = "methane",
		"H2" = "hydrogen",
		"He" = "helium",
		"Ar" = "argon",
		"Kr" = "krypton",
		"Ne" = "neon",
		"Xe" = "xenon",
		"NO2" = "nitrodioxide",
		"NO" = "nitricoxide",
		"Cl" = "chlorine"
		)

	//Upgrades
	var/extract_speed
	var/extract_efficiency
	var/obj/item/weapon/cell/cell = null

	//Flags
	var/need_update_field = 0

/obj/machinery/fracking/New()

	..()

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/fracking(src)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/cell/high(src)

	RefreshParts()

/obj/machinery/fracking/Process()
	if(!active || !anchored || !use_cell_power()) return

	if(need_update_field)
		get_gas_field()

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
		T.ex_act(2.0)

	//Ruin the environment.
	if(gas_field.len)
		var/turf/simulated/harvesting = pick(gas_field)

		while(gas_field.len && !harvesting.gases)
			harvesting.has_gasess = 0
			harvesting.gases = null
			gas_field -= harvesting
			if(gas_field.len)
				harvesting = pick(gas_field)

		if(!harvesting) return

		var/found_gas = 0 //If this doesn't get set, the area is depleted.
		var/harvest_gas = extract_speed

		for(var/gas in gas_types)

			if(harvest_gas <= 0) break
			if(harvesting.gases[gas])
				found_gas = 1

				var/create_gas = 0
				if(harvesting.gases[gas] >= harvest_gas)
					harvesting.gases[gas] -= harvest_gas
					create_gas = harvest_gas
					harvest_gas = 0
				else
					harvest_gas -= harvesting.gases[gas]
					create_gas = harvesting.gases[gas]
					harvesting.gases[gas] = 0

				for(var/i=1, i <= create_gas, i++)
					var/gastype = gas_types[gas]
					// TODO: Add one atmosphere of gas to an adjacent pipe

		if(!found_resource)
			harvesting.has_gases = 0
			harvesting.gases = null
			resource_field -= harvesting
	else
		active = 0
		update_icon()

/obj/machinery/fracking/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/fracking/attackby(obj/item/O as obj, mob/user as mob)
	if(!active)
		if(default_deconstruction_screwdriver(user, O))
			return
		if(default_deconstruction_crowbar(user, O))
			return
		if(default_part_replacement(user, O))
			return
	if(!panel_open || active) return ..()

	if(istype(O, /obj/item/weapon/cell))
		if(cell)
			to_chat(user, "The extractor already has a cell installed.")
		else
			user.drop_item()
			O.loc = src
			cell = O
			component_parts += O
			to_chat(user, "You install \the [O].")
		return
	..()

/obj/machinery/fracking/attack_hand(mob/user as mob)
	if (panel_open && cell && user.Adjacent(src))
		to_chat(user, "You take out \the [cell].")
		cell.loc = get_turf(user)
		component_parts -= cell
		cell = null
		return
	else if(!panel_open)
		if(use_cell_power())
			active = !active
			if(active)
				visible_message("<span class='notice'>\The [src] begins extracting natural gas from the ground.</span>")
				need_update_field = 1
			else
				visible_message("<span class='notice'>\The [src] halts the extraction process.</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] is unpowered.</span>")
	else
		to_chat(user, "<span class='notice'>The maintenance panel on \the [src] is opened.</span>")

	update_icon()

/obj/machinery/fracking/update_icon()
	if(active)
		icon_state = "mining_drill_active"
	else
		icon_state = "mining_drill"
	return

/obj/machinery/fracking/RefreshParts()
	..()
	extract_speed = 0
	extract_efficiency = 0
	var/charge_multiplier = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/micro_laser))
			extract_speed = P.rating
		if(istype(P, /obj/item/weapon/stock_parts/scanning_module))
			extract_efficiency = P.rating
		if(istype(P, /obj/item/weapon/stock_parts/capacitor))
			charge_multiplier += P.rating
	cell = locate(/obj/item/weapon/cell) in component_parts
	if(charge_multiplier)
		actual_power_usage = base_power_usage / charge_multiplier
	else
		actual_power_usage = base_power_usage

/obj/machinery/fracking/proc/get_gas_field()

	gas_field = list()
	need_update_field = 0

	var/turf/T = get_turf(src)
	if(!istype(T)) return

	var/tx = T.x - 2
	var/ty = T.y - 2
	var/turf/simulated/gas_turf
	for(var/iy = 0,iy < 5, iy++)
		for(var/ix = 0, ix < 5, ix++)
			gas_turf = locate(tx + ix, ty + iy, T.z)
			if(gas_turf && gas_turf.has_gases)
				gas_field += gas_turf

	if(!gas_field.len)
		active = 0
		update_icon()

/obj/machinery/fracking/proc/use_cell_power()
	return cell && cell.checked_use(actual_power_usage * CELLRATE)
