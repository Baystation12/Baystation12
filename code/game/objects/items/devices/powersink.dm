// Powersink - used to drain station power

/obj/item/device/powersink
	name = "power sink"
	desc = "A nulling power sink which drains energy from electrical systems."
	icon = 'icons/obj/power_sink.dmi'
	icon_state = "powersink0"
	item_state = "electronic"
	w_class = ITEM_SIZE_LARGE
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	throwforce = 5
	throw_speed = 1
	throw_range = 2

	matter = list(MATERIAL_STEEL = 750,MATERIAL_WASTE = 750)

	origin_tech = list(TECH_POWER = 3, TECH_ESOTERIC = 5)
	var/drain_rate = 15000000		// amount of power to drain per tick
	var/apc_drain_rate = 10000 		// Max. amount drained from single APC. In Watts.
	var/dissipation_rate = 20000	// Passive dissipation of drained power. In Watts.
	var/power_drained = 0 			// Amount of power drained.
	var/max_power = 5e10				// Detonation point.
	var/mode = 0					// 0 = off, 1=clamped (off), 2=operating
	var/datum/powernet/PN			// Our powernet

	var/const/DISCONNECTED = 0
	var/const/CLAMPED_OFF = 1
	var/const/OPERATING = 2

	var/obj/structure/cable/attached		// the attached cable

/obj/item/device/powersink/on_update_icon()
	icon_state = "powersink[mode == OPERATING]"

/obj/item/device/powersink/proc/set_mode(value)
	if(value == mode)
		return
	switch(value)
		if(DISCONNECTED)
			attached = null
			if(mode == OPERATING)
				STOP_PROCESSING_POWER_OBJECT(src)
			anchored = FALSE

		if(CLAMPED_OFF)
			if(!attached)
				return
			if(mode == OPERATING)
				STOP_PROCESSING_POWER_OBJECT(src)
			anchored = TRUE

		if(OPERATING)
			if(!attached)
				return
			START_PROCESSING_POWER_OBJECT(src)
			anchored = TRUE

	mode = value
	update_icon()
	set_light(0)

/obj/item/device/powersink/Destroy()
	if(mode == 2)
		STOP_PROCESSING_POWER_OBJECT(src)
	. = ..()


/obj/item/device/powersink/use_tool(obj/item/tool, mob/user, list/click_params)
	// Screwdriver - Toggle connection to cable
	if (isScrewdriver(tool))
		if (mode != DISCONNECTED)
			user.visible_message(
				SPAN_NOTICE("\The [user] detaches \a [src] from \the [attached] with \a [tool]."),
				SPAN_NOTICE("You detach \the [src] from \the [attached] with \the [tool].")
			)
			set_mode(DISCONNECTED)
			return TRUE
		if (!isturf(loc))
			USE_FEEDBACK_FAILURE("\The [src] must be placed on the ground before you can connect it.")
			return TRUE
		var/turf/turf = loc
		if (!turf.is_plating())
			USE_FEEDBACK_FAILURE("\The [turf]'s plating must be removed before you can connect \the [src].")
			return TRUE
		attached = locate() in turf
		if (!attached)
			USE_FEEDBACK_FAILURE("\The [src] must be placed over an exposed, powered cable node before it can be connected.")
			return TRUE
		set_mode(CLAMPED_OFF)
		user.visible_message(
			SPAN_NOTICE("\The [user] attaches \a [src] to \the [attached] with \a [tool]."),
			SPAN_NOTICE("You attach \the [src] to \the [attached] with \the [tool].")
		)
		return TRUE

	return ..()


/obj/item/device/powersink/attack_ai()
	return

/obj/item/device/powersink/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	switch(mode)
		if(DISCONNECTED)
			..()

		if(CLAMPED_OFF)
			user.visible_message( \
				"[user] activates \the [src]!", \
				SPAN_NOTICE("You activate \the [src]."),
				SPAN_CLASS("italics", "You hear a click."))
			message_admins("Power sink activated by [key_name_admin(user)] at (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
			log_game("Power sink activated by [key_name(user)] at [get_area_name(src)]")
			set_mode(OPERATING)

		if(OPERATING)
			user.visible_message( \
				"[user] deactivates \the [src]!", \
				SPAN_NOTICE("You deactivate \the [src]."),
				SPAN_CLASS("italics", "You hear a click."))
			set_mode(CLAMPED_OFF)

/obj/item/device/powersink/pwr_drain()
	if(!attached)
		set_mode(DISCONNECTED)
		return

	var/datum/powernet/PN = attached.powernet
	var/drained = 0
	if(PN)
		set_light(0.5, 0.1, 12)
		PN.trigger_warning()
		// found a powernet, so drain up to max power from it
		drained = PN.draw_power(drain_rate)
		// if tried to drain more than available on powernet
		// now look for APCs and drain their cells
		if(drained < drain_rate)
			for(var/obj/machinery/power/terminal/T in PN.nodes)
				// Enough power drained this tick, no need to torture more APCs
				if(drained >= drain_rate)
					break
				var/obj/machinery/power/apc/A = T.master_machine()
				if(istype(A))
					drained += A.drain_power(amount = drain_rate)
		power_drained += drained

	if(power_drained > max_power * 0.95)
		playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
	if(power_drained >= max_power)
		STOP_PROCESSING_POWER_OBJECT(src)
		explosion(src.loc, 18)
		qdel(src)
