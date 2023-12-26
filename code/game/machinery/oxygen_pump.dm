#define TANK_MAX_RELEASE_PRESSURE (3*ONE_ATMOSPHERE)
#define TANK_DEFAULT_RELEASE_PRESSURE ONE_ATMOSPHERE

/obj/machinery/oxygen_pump
	name = "emergency oxygen pump"
	icon = 'icons/obj/structures/walllocker.dmi'
	desc = "A wall mounted oxygen pump with a retractable face mask that you can pull over your face in case of emergencies."
	icon_state = "emerg"

	anchored = TRUE

	var/obj/item/tank/tank
	var/mob/living/carbon/breather
	var/obj/item/clothing/mask/breath/contained

	var/spawn_type = /obj/item/tank/oxygen_emergency_extended
	var/mask_type = /obj/item/clothing/mask/breath/emergency
	var/icon_state_open = "emerg_open"
	var/icon_state_closed = "emerg"

	power_channel = ENVIRON
	idle_power_usage = 10
	active_power_usage = 120 // No idea what the realistic amount would be.

/obj/machinery/oxygen_pump/New()
	..()
	tank = new spawn_type (src)
	contained = new mask_type (src)
	GLOB.destroyed_event.register(tank, src, .proc/fix_deleted_tank)
	GLOB.destroyed_event.register(contained, src, .proc/fix_deleted_mask)

/obj/machinery/oxygen_pump/Destroy()
	if(breather)
		detach_mask(breather)
	GLOB.destroyed_event.unregister(tank, src, .proc/fix_deleted_tank)
	GLOB.destroyed_event.unregister(contained, src, .proc/fix_deleted_mask)
	QDEL_NULL(tank)
	QDEL_NULL(contained)
	return ..()

/// Handler for the pump's tank being deleted, for any reason.
/obj/machinery/oxygen_pump/proc/fix_deleted_tank(obj/item/tank/_tank)
	GLOB.destroyed_event.unregister(_tank, src, .proc/fix_deleted_tank)
	tank = new spawn_type(src)
	GLOB.destroyed_event.register(tank, src, .proc/fix_deleted_tank)

/// Handler for the pump's mask being deleted, for any reason.
/obj/machinery/oxygen_pump/proc/fix_deleted_mask(obj/item/clothing/mask/breath/_mask)
	GLOB.destroyed_event.unregister(_mask, src, .proc/fix_deleted_mask)
	contained = new spawn_type(src)
	GLOB.destroyed_event.register(contained, src, .proc/fix_deleted_mask)

/obj/machinery/oxygen_pump/MouseDrop(mob/living/carbon/human/target, src_location, over_location)
	..()
	if(istype(target) && CanMouseDrop(target))
		if(!can_apply_to_target(target, usr)) // There is no point in attempting to apply a mask if it's impossible.
			return
		usr.visible_message("\The [usr] begins placing the mask onto [target]..")
		if(do_after(usr, 2.5 SECONDS, src, DO_PUBLIC_UNIQUE))
			if(!can_apply_to_target(target, usr))
				return
			// place mask and add fingerprints
			usr.visible_message("\The [usr] has placed \the mask on [target]'s mouth.")
			attach_mask(target)
			src.add_fingerprint(usr)


/obj/machinery/oxygen_pump/physical_attack_hand(mob/user)
	if(GET_FLAGS(stat, MACHINE_STAT_MAINT) && tank)
		user.visible_message(SPAN_NOTICE("\The [user] removes \the [tank] from \the [src]."), SPAN_NOTICE("You remove \the [tank] from \the [src]."))
		user.put_in_hands(tank)
		src.add_fingerprint(user)
		tank.add_fingerprint(user)
		tank = null
		return TRUE
	if(breather)
		detach_mask(user)
		return TRUE

/obj/machinery/oxygen_pump/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/oxygen_pump/proc/attach_mask(mob/living/carbon/C)
	if(C && istype(C))
		contained.dropInto(C.loc)
		C.equip_to_slot(contained, slot_wear_mask)
		if(tank)
			tank.forceMove(C)
		breather = C
		GLOB.destroyed_event.register(breather, src, .proc/detach_mask)

/obj/machinery/oxygen_pump/proc/set_internals(mob/living/carbon/C)
	if(C && istype(C))
		if(!C.internal && tank)
			breather.set_internals(tank)
		update_use_power(POWER_USE_ACTIVE)

/obj/machinery/oxygen_pump/proc/detach_mask(mob/user)
	if(tank)
		tank.forceMove(src)
	breather.drop_from_inventory(contained, src)
	if(user)
		visible_message(SPAN_NOTICE("\The [user] detaches \the [contained] and it rapidly retracts back into \the [src]!"))
	else
		visible_message(SPAN_NOTICE("\The [contained] rapidly retracts back into \the [src]!"))
	if(breather.internals)
		breather.internals.icon_state = "internal0"
	GLOB.destroyed_event.unregister(breather, src, .proc/detach_mask)
	breather = null
	update_use_power(POWER_USE_IDLE)

/obj/machinery/oxygen_pump/proc/can_apply_to_target(mob/living/carbon/human/target, mob/user as mob)
	if(!user)
		user = target
	// Check target validity
	if(!target.organs_by_name[BP_HEAD])
		to_chat(user, SPAN_WARNING("\The [target] doesn't have a head."))
		return
	if(!target.check_has_mouth())
		to_chat(user, SPAN_WARNING("\The [target] doesn't have a mouth."))
		return
	if(target.wear_mask && target != breather)
		to_chat(user, SPAN_WARNING("\The [target] is already wearing a mask."))
		return
	if(target.head && (target.head.body_parts_covered & FACE))
		to_chat(user, SPAN_WARNING("Remove their [target.head] first."))
		return
	if(!tank)
		to_chat(user, SPAN_WARNING("There is no tank in \the [src]."))
		return
	if(GET_FLAGS(stat, MACHINE_STAT_MAINT))
		to_chat(user, SPAN_WARNING("Please close the maintenance hatch first."))
		return
	if(!Adjacent(target))
		to_chat(user, SPAN_WARNING("Please stay close to \the [src]."))
		return
	//when there is a breather:
	if(breather && target != breather)
		to_chat(user, SPAN_WARNING("The pump is already in use."))
		return
	//Checking if breather is still valid
	if(target == breather && target.wear_mask != contained)
		to_chat(user, SPAN_WARNING("\The [target] is not using the supplied mask."))
		return
	return 1

/obj/machinery/oxygen_pump/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isScrewdriver(W))
		toggle_stat(MACHINE_STAT_MAINT)
		user.visible_message(
			SPAN_NOTICE("\The [user] [GET_FLAGS(stat, MACHINE_STAT_MAINT) ? "opens" : "closes"] \the [src]."),
			SPAN_NOTICE("You [GET_FLAGS(stat, MACHINE_STAT_MAINT) ? "open" : "close"] \the [src].")
		)
		if(GET_FLAGS(stat, MACHINE_STAT_MAINT))
			icon_state = icon_state_open
		if(!stat)
			icon_state = icon_state_closed
		return TRUE

	if(istype(W, /obj/item/tank) && (GET_FLAGS(stat, MACHINE_STAT_MAINT)))
		if(tank)
			to_chat(user, SPAN_WARNING("\The [src] already has a tank installed!"))
			return TRUE

		if(!user.unEquip(W, src))
			return TRUE
		tank = W
		user.visible_message(SPAN_NOTICE("\The [user] installs \the [tank] into \the [src]."), SPAN_NOTICE("You install \the [tank] into \the [src]."))
		return TRUE

	if(istype(W, /obj/item/tank) && !stat)
		to_chat(user, SPAN_WARNING("You need to open the maintenance hatch first."))
		return TRUE

	return ..()

/obj/machinery/oxygen_pump/examine(mob/user)
	. = ..()
	if(tank)
		to_chat(user, "The meter shows [round(tank.air_contents.return_pressure())]")
	else
		to_chat(user, SPAN_WARNING("It is missing a tank!"))


/obj/machinery/oxygen_pump/Process()
	if(breather)
		if(!can_apply_to_target(breather))
			detach_mask()
		else if(!breather.internal && tank)
			set_internals(breather)


//Create rightclick to view tank settings
/obj/machinery/oxygen_pump/verb/settings()
	set src in oview(1)
	set category = "Object"
	set name = "Show Tank Settings"
	ui_interact(usr)

//GUI Tank Setup
/obj/machinery/oxygen_pump/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/data[0]
	if(!tank)
		to_chat(usr, SPAN_WARNING("It is missing a tank!"))
		data["tankPressure"] = 0
		data["releasePressure"] = 0
		data["defaultReleasePressure"] = 0
		data["maxReleasePressure"] = 0
		data["maskConnected"] = 0
		data["tankInstalled"] = 0
	// this is the data which will be sent to the ui
	if(tank)
		data["tankPressure"] = round(tank.air_contents.return_pressure() ? tank.air_contents.return_pressure() : 0)
		data["releasePressure"] = round(tank.distribute_pressure ? tank.distribute_pressure : 0)
		data["defaultReleasePressure"] = round(TANK_DEFAULT_RELEASE_PRESSURE)
		data["maxReleasePressure"] = round(TANK_MAX_RELEASE_PRESSURE)
		data["maskConnected"] = 0
		data["tankInstalled"] = 1

	if(!breather)
		data["maskConnected"] = 0
	if(breather)
		data["maskConnected"] = 1


	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "Oxygen_pump.tmpl", "Tank", 500, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/oxygen_pump/Topic(href, href_list)
	if(..())
		return 1

	if (href_list["dist_p"])
		if (href_list["dist_p"] == "reset")
			tank.distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
		else if (href_list["dist_p"] == "max")
			tank.distribute_pressure = TANK_MAX_RELEASE_PRESSURE
		else
			var/cp = text2num(href_list["dist_p"])
			tank.distribute_pressure += cp
		tank.distribute_pressure = min(max(round(tank.distribute_pressure), 0), TANK_MAX_RELEASE_PRESSURE)
		return 1
