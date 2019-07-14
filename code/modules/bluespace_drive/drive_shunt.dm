/obj/item/weapon/cell/power_shunt
	name = "power shunt battery"
	charge = 0
	maxcharge = 10000

/obj/machinery/power/shunt
	name = "power shunt"
	desc = "A hefty piece of machinery that helps regulate the bluespace drive and feed it power."
	anchored = TRUE
	density = TRUE
	w_class = ITEM_SIZE_HUGE
	icon = 'icons/obj/bluespace_drive.dmi'
	icon_state = "drive_shunt"
	active_power_usage = 100 KILOWATTS // The jump drive takes a lot of power.

	var/obj/item/weapon/cell/power_shunt/cell
	var/obj/machinery/drive_core/drive
	var/shunt_state = 0

/obj/machinery/power/shunt/Initialize()
	. = ..()
	update_connection()
	cell = new(src)

/obj/machinery/power/shunt/Destroy()
	if(drive)
		drive.remove_shunt(src)
	QDEL_NULL(cell)
	. = ..()

/obj/machinery/power/shunt/proc/update_connection()
	icon_state = initial(icon_state)
	pixel_z = 0
	if(anchored)
		if(drive)
			drive.remove_shunt(src)
		for(var/checkdir in GLOB.cardinal)
			var/turf/T = get_step(loc, checkdir)
			if(T)
				var/obj/machinery/drive_core/D = locate() in T
				if(D)
					D.add_shunt(src)
					break
	update_icon()

/obj/machinery/power/shunt/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("The charge indicator reads <b>[cell ? cell.percent() : 0]%</b>."))

/obj/machinery/power/shunt/on_update_icon()
	if(drive)
		icon_state = "[initial(icon_state)]_attached"
		var/offset_y = drive.shunt_offsets["[dir]"]
		if(!isnull(offset_y))
			pixel_z = offset_y
	else
		icon_state = initial(icon_state)
		pixel_z = 0

/obj/machinery/power/shunt/Process()

	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(POWER_USE_OFF)
		return

	if(cell && !cell.fully_charged())
		cell.give(active_power_usage*CELLRATE)
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)