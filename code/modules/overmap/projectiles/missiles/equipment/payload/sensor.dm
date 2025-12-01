// Lights up the overmap
/obj/item/missile_equipment/payload/sensor
	name = "sensor probe"
	desc = "A portable sensor probe that provides information about nearby sectors and feeds it back to a designated mothership."
	icon_state = "probe"
	matter = list(MATERIAL_ALUMINIUM = 4000, MATERIAL_SILVER = 50, MATERIAL_GOLD = 50, MATERIAL_GLASS = 2000)

	cooldown = 10 SECONDS
	missile_name_override = "sensor probe"
	missile_overmap_name_override = "sensor probe"
	enters_zs = FALSE
	is_dangerous = FALSE

	var/sensor_range = 2
	var/power_draw = 30 KILOWATTS // per sensor range
	var/obj/item/cell/cell = null
	var/obj/overmap/visitable/ship/linked = null

/obj/item/missile_equipment/payload/sensor/Initialize()
	. = ..()
	cell = new /obj/item/cell/standard(src)
	GLOB.destroyed_event.register(cell, src, .proc/cell_qdel)

/obj/item/missile_equipment/payload/sensor/examine(mob/user)
	. = ..()
	if (cell)
		to_chat(user, "It has \a [cell] installed.")
	else
		to_chat(user, SPAN_WARNING("It is missing a power cell."))

/obj/item/missile_equipment/payload/sensor/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_MULTITOOL] = "<p>Sets sensor range. Higher settings cost more power.</p>"
	.[CODEX_INTERACTION_SCREWDRIVER] = "<p>Removes the attached power cell.</p>"
	.["Power Cell"] = "<p>Adds power cell to the payload.</p>"

/obj/item/missile_equipment/payload/sensor/proc/cell_qdel()
	GLOB.destroyed_event.unregister(cell, src)
	cell = null

/obj/item/missile_equipment/payload/sensor/Destroy()
	if (linked)
		for (var/obj/machinery/shipsensors/sensor in linked.sensors)
			var/obj/structure/missile/parent = loc
			if (parent && istype(parent))
				sensor.remove_external_source(parent.overmap_missile)
	GLOB.destroyed_event.unregister(cell, src)
	QDEL_NULL(cell)
	. = ..()

/obj/item/missile_equipment/payload/sensor/can_configure()
	return TRUE

/obj/item/missile_equipment/payload/sensor/configure(mob/user)
	var/new_sensors_range = input("Input sensors range (1 to 5)") as num|null
	if (new_sensors_range)
		sensor_range = clamp(new_sensors_range, 1, 5)
		to_chat(user, SPAN_NOTICE("Sensor range successfully set to [new_sensors_range]."))
	return TRUE

/obj/item/missile_equipment/payload/sensor/use_tool(obj/item/tool, mob/user)
	if (isScrewdriver(tool) && !isnull(cell))
		user.put_in_hands(cell)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \a [cell] from \the [src]."),
			SPAN_NOTICE("You remove \the [cell] from \the [src].")
		)
		cell = null
		return TRUE

	if (istype(tool, /obj/item/cell) && isnull(cell))
		if (!user.unEquip(tool, src))
			return TRUE
		cell = tool
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		return TRUE
	return ..()

/obj/item/missile_equipment/payload/sensor/proc/sync_linked()
	linked = get_owning_sector_recursive(loc)

// Make sure the probe stays on the overmap
/obj/item/missile_equipment/payload/sensor/on_missile_armed(obj/overmap/projectile/overmap_missile)
	..()
	sync_linked()

/obj/item/missile_equipment/payload/sensor/on_touch_map_edge(obj/overmap/projectile/overmap_missile)
	if (!..())
		return FALSE
	if (linked)
		for (var/obj/machinery/shipsensors/sensor in linked.sensors)
			sensor.link_external_source(overmap_missile, sensor_range)
	return TRUE

/obj/item/missile_equipment/payload/sensor/do_overmap_work(obj/overmap/projectile/overmap_missile)
	if (!..())
		return FALSE
	if (isnull(cell) || !cell.checked_use(power_draw*sensor_range*CELLRATE))
		if (linked)
			for (var/obj/machinery/shipsensors/sensor in linked.sensors)
				sensor.remove_external_source(overmap_missile)
		qdel(overmap_missile)
	return TRUE
