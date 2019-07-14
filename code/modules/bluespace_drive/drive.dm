/obj/machinery/drive_core
	name = "drive core"
	desc = "A bulky, power-hungry machine of Skrellian design, used to translate spacecraft across the Universe at superluminal speeds."
	icon = 'icons/obj/bluespace_drive.dmi'
	icon_state = "drive_core"
	anchored = TRUE
	density = TRUE
	w_class = ITEM_SIZE_GARGANTUAN

	var/destroyed = FALSE
	var/list/shunts = list()
	var/list/shunt_offsets = list()

	var/charge_target =      0
	var/accumulated_charge = 0
	var/jump_target_x
	var/jump_target_y

/obj/machinery/drive_core/proc/is_functional()
	if(destroyed)
		return FALSE
	for(var/thing in shunts)
		var/obj/machinery/power/shunt/shunt = thing
		if(shunt.cell)
			return TRUE
	return FALSE

/obj/machinery/drive_core/Initialize()
	. = ..()
	shunt_offsets = list(
		"[NORTH]" = 22,
		"[SOUTH]" = -22,
		"[EAST]" = 0,
		"[WEST]" = 0,
	)
	GLOB.bluespace_drives += src
	for(var/checkdir in GLOB.cardinal)
		var/turf/T = get_step(loc, checkdir)
		if(T)
			for(var/obj/machinery/power/shunt/shunt in T)
				add_shunt(shunt)
	set_light(0.8, 1, 6, COLOR_BLUE_LIGHT)

/obj/machinery/drive_core/Destroy()
	GLOB.bluespace_drives -= src
	for(var/thing in shunts)
		remove_shunt(thing)
	. = ..()

/obj/machinery/drive_core/proc/add_shunt(var/obj/machinery/power/shunt/shunt)
	shunt.shunt_state |= SHUNT_STATE_LOCKED
	if(shunt.drive)
		shunt.drive.shunts -= shunt
	shunt.drive = src
	shunts |= shunt
	shunt.set_dir(get_dir(shunt, src))
	shunt.update_icon()
	update_icon()

/obj/machinery/drive_core/proc/remove_shunt(var/obj/machinery/power/shunt/shunt)
	shunts -= shunt
	shunt.drive = null
	shunt.shunt_state &= ~SHUNT_STATE_LOCKED
	shunt.update_icon()
	update_icon()

/obj/machinery/drive_core/proc/start_spool()
	if(spooling)
		return FALSE
	visible_message("\The [src] starts spooling!")
	spooling = TRUE
	charge_target = 100000

/obj/machinery/drive_core/proc/cancel_spool()
	shed_charge()
	spooling = FALSE
	visible_message("\The [src] cancels spooling.")
	return TRUE

/obj/machinery/drive_core/proc/shed_charge()
	accumulated_charge = 0

/obj/machinery/drive_core/proc/finish_spooling(var/forced)
	if(forced || spooling)
		spooling = FALSE
		accumulated_charge = 0
		charge_target = 0
		visible_message("\The [src] finishes spooling!")
		var/sabotage = Clamp(is_sabotaged(), 0, 3)
		if(sabotage != 0)
			var/decl/drive_failure/failure = decls_repository.get_decl(drive_failures[sabotage])
			failure.invoke(src)
			return FALSE
		return TRUE
	return FALSE

/obj/machinery/drive_core/Process()
	if(!spooling)
		return

	if((stat & NOPOWER) || length(shunts) <= 0)
		cancel_spool()
		return

	for(var/thing in shunts)
		var/obj/machinery/power/shunt/shunt = thing
		if(shunt.cell)
			var/val = 100
			shunt.cell.use(val)
			accumulated_charge += val
			if(accumulated_charge >= charge_target)
				break

	if(accumulated_charge >= charge_target)
		finish_spooling()
