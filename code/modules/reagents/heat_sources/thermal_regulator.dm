#define MINIMUM_GLOW_TEMPERATURE 323
#define MINIMUM_GLOW_VALUE       25
#define MAXIMUM_GLOW_VALUE       255

/obj/machinery/reagent_temperature
	name = "thermal regulator"
	desc = "A small electric device used to heat and cool chemicals."
	icon = 'icons/obj/machines/medical/thermal_regulator.dmi'
	icon_state = "regulator"
	atom_flags = ATOM_FLAG_CLIMBABLE
	obj_flags = OBJ_FLAG_CAN_TABLE | OBJ_FLAG_ANCHORABLE
	anchored = TRUE
	idle_power_usage = 0
	active_power_usage = 1.2 KILOWATTS
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	machine_name = "thermal regulator"
	machine_desc = "A small, configurable plate used to heat and cool chemical containers."

	var/image/glow_icon
	var/image/beaker_icon
	var/image/on_icon

	var/heating =			   TRUE
	var/list/permitted_types = list(/obj/item/reagent_containers/glass)
	var/max_temperature =      200 CELSIUS
	var/min_temperature =      -100  CELSIUS
	var/heating_power =        10 // K
	var/last_temperature
	var/target_temperature
	var/obj/item/container

/obj/machinery/reagent_temperature/Initialize()
	target_temperature = 50 CELSIUS
	. = ..()

/obj/machinery/reagent_temperature/Destroy()
	if(container)
		container.dropInto(loc)
		container = null
	. = ..()

/obj/machinery/reagent_temperature/RefreshParts()
	heating_power = initial(heating_power) * clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 0, 10)

	var/comp = 0.25 KILOWATTS * total_component_rating_of_type(/obj/item/stock_parts/micro_laser)
	if(comp)
		change_power_consumption(max(0.5 KILOWATTS, initial(active_power_usage) - comp), POWER_USE_ACTIVE)
	..()

/obj/machinery/reagent_temperature/Process()
	..()
	if(temperature != last_temperature)
		queue_icon_update()
	if(((inoperable()) || !anchored) && use_power >= POWER_USE_ACTIVE)
		update_use_power(POWER_USE_IDLE)
		queue_icon_update()

/obj/machinery/reagent_temperature/proc/eject_beaker(mob/user)
	if(!container)
		return
	var/obj/item/reagent_containers/B = container
	user.put_in_hands(B)
	container = null
	update_icon()

/obj/machinery/reagent_temperature/AltClick(mob/user)
	if(CanDefaultInteract(user))
		eject_beaker(user)
		return TRUE
	return ..()

/obj/machinery/reagent_temperature/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/reagent_temperature/ProcessAtomTemperature()
	if(use_power >= POWER_USE_ACTIVE)
		var/last_temperature = temperature
		if(heating && temperature < target_temperature)
			temperature = min(target_temperature, temperature + heating_power)
		else if(!heating && temperature > target_temperature)
			temperature = max(target_temperature, temperature - heating_power)
		if(temperature != last_temperature)
			if(container)
				QUEUE_TEMPERATURE_ATOMS(container)
			queue_icon_update()
		return TRUE // Don't kill this processing loop unless we're not powered.
	. = ..()

/obj/machinery/reagent_temperature/use_tool(obj/item/thing, mob/living/user, list/click_params)
	if(isWrench(thing) && use_power == POWER_USE_ACTIVE)
		to_chat(user, SPAN_WARNING("Turn \the [src] off first!"))
		return TRUE

	if(thing.reagents)
		for(var/checktype in permitted_types)
			if(istype(thing, checktype))
				if(container)
					to_chat(user, SPAN_WARNING("\The [src] is already holding \the [container]."))
				else if(user.unEquip(thing))
					thing.forceMove(src)
					container = thing
					visible_message(SPAN_NOTICE("\The [user] places \the [container] on \the [src]."))
					update_icon()
				return TRUE
		to_chat(user, SPAN_WARNING("\The [src] cannot accept \the [thing]."))
		return TRUE

	return ..()

/obj/machinery/reagent_temperature/on_update_icon()
	ClearOverlays()

	var/list/adding_overlays

	if(use_power >= POWER_USE_ACTIVE)
		if(!on_icon)
			on_icon = image(icon, "[icon_state]_lights")
			AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		LAZYADD(adding_overlays, on_icon)
		if(temperature > MINIMUM_GLOW_TEMPERATURE) // 50C
			if(!glow_icon)
				glow_icon += emissive_appearance(icon, "[icon_state]_lights_[heating ? "cold" : "hot"]")
				AddOverlays(emissive_appearance(icon, "[icon_state]_lights_cold"))
			glow_icon.alpha = clamp(temperature - MINIMUM_GLOW_TEMPERATURE, MINIMUM_GLOW_VALUE, MAXIMUM_GLOW_VALUE)
			LAZYADD(adding_overlays, glow_icon)
			set_light(1, 0.2, l_color = COLOR_GREEN)
		else
			set_light(0)
	else
		set_light(0)

	if(panel_open)
		AddOverlays("[icon_state]_panel")

	if(container)
		if(!beaker_icon)
			beaker_icon = image(icon, "[icon_state]_beaker")
		LAZYADD(adding_overlays, beaker_icon)

	SetOverlays(adding_overlays)

/obj/machinery/reagent_temperature/interact(mob/user)

	var/dat = list()
	dat += "<table>"

	dat += "<tr><td>Temperature Mode:</td><td><a href='?src=\ref[src];switch_mode=heating'>[heating ? "Heat" : "Chill"]</a></td></tr>"

	dat += "<tr><td>Target temperature:</td><td>"

	if(target_temperature > min_temperature)
		dat += "<a href='?src=\ref[src];adjust_temperature=-[heating_power]'>-</a> "

	dat += "[target_temperature - T0C]C"

	if(target_temperature < max_temperature)
		dat += " <a href='?src=\ref[src];adjust_temperature=[heating_power]'>+</a>"

	dat += "</td></tr>"

	dat += "<tr><td>Current temperature:</td><td>[floor(temperature - T0C)]C</td></tr>"

	dat += "<tr><td>Loaded container:</td>"
	dat += "<td>[container ? "[container.name] ([floor(container.temperature - T0C)]C) <a href='?src=\ref[src];remove_container=1'>Remove</a>" : "None."]</td></tr>"

	dat += "<tr><td>Switched:</td><td><a href='?src=\ref[src];toggle_power=1'>[use_power == POWER_USE_ACTIVE ? "On" : "Off"]</a></td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "\ref[src]-reagent_temperature_window", "[capitalize(name)]")
	popup.set_content(jointext(dat, null))
	popup.open()

/obj/machinery/reagent_temperature/CanUseTopic(mob/user, state, href_list)
	if(href_list && href_list["remove_container"])
		. = ..(user, GLOB.physical_state, href_list)
		if(. == STATUS_CLOSE)
			to_chat(user, SPAN_WARNING("You are too far away."))
		return
	return ..()

/obj/machinery/reagent_temperature/proc/ToggleUsePower()

	if(inoperable())
		return TOPIC_HANDLED

	update_use_power(use_power <= POWER_USE_IDLE ? POWER_USE_ACTIVE : POWER_USE_IDLE)
	QUEUE_TEMPERATURE_ATOMS(src)
	update_icon()

	return TOPIC_REFRESH

/obj/machinery/reagent_temperature/proc/ToggleMode()
	heating = !heating
	update_icon()

	return TOPIC_REFRESH

/obj/machinery/reagent_temperature/OnTopic(mob/user, href_list)

	if(href_list["adjust_temperature"])
		target_temperature = clamp(target_temperature + text2num(href_list["adjust_temperature"]), min_temperature, max_temperature)
		. = TOPIC_REFRESH

	if(href_list["toggle_power"])
		. = ToggleUsePower()
		if(. != TOPIC_REFRESH)
			to_chat(user, SPAN_WARNING("The button clicks, but nothing happens."))

	if(href_list["remove_container"])
		eject_beaker(user)
		. = TOPIC_REFRESH

	if(href_list["switch_mode"])
		ToggleMode()
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)

#undef MINIMUM_GLOW_TEMPERATURE
#undef MINIMUM_GLOW_VALUE
#undef MAXIMUM_GLOW_VALUE
