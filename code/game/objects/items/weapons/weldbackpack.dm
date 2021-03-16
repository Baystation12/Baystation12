/obj/item/weldpack
	name = "welding kit"
	desc = "An unwieldy, heavy backpack with two massive fuel tanks. Includes a connector for most models of portable welding tools."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage.dmi'
	icon_state = "welderpack"
	w_class = ITEM_SIZE_HUGE
	var/max_fuel = 350
	var/obj/item/weldingtool/welder

/obj/item/weldpack/Initialize()
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)

	. = ..()

/obj/item/weldpack/Destroy()
	QDEL_NULL(welder)

	. = ..()

/obj/item/weldpack/attackby(obj/item/W as obj, mob/user as mob)
	if(isWelder(W))
		var/obj/item/weldingtool/T = W
		if(T.welding & prob(50))
			log_and_message_admins("triggered a fueltank explosion.", user)
			to_chat(user, "<span class='danger'>That was stupid of you.</span>")
			explosion(get_turf(src),-1,0,2)
			if(src)
				qdel(src)
			return
		else
			if(T.welding)
				to_chat(user, "<span class='danger'>That was close!</span>")
			if(!T.tank)
				to_chat(user, "\The [T] has no tank attached!")
			src.reagents.trans_to_obj(T.tank, T.tank.max_fuel)
			to_chat(user, "<span class='notice'>You refuel \the [W].</span>")
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			return
	else if(istype(W, /obj/item/welder_tank))
		var/obj/item/welder_tank/tank = W
		src.reagents.trans_to_obj(tank, tank.max_fuel)
		to_chat(user, "<span class='notice'>You refuel \the [W].</span>")
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return

	to_chat(user, "<span class='warning'>The tank will accept only a welding tool or cartridge.</span>")
	return

/obj/item/weldpack/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) // this replaces and improves the get_dist(src,O) <= 1 checks used previously
		return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume < max_fuel)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, "<span class='notice'>You crack the cap off the top of the pack and fill it back up again from the tank.</span>")
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		return
	else if (istype(O, /obj/structure/reagent_dispensers/fueltank) && src.reagents.total_volume == max_fuel)
		to_chat(user, "<span class='warning'>The pack is already full!</span>")
		return

/obj/item/weldpack/attack_hand(mob/user as mob)
	if(welder && user.get_inactive_hand() == src)
		user.put_in_hands(welder)
		user.visible_message("[user] removes \the [welder] from \the [src].", "You remove \the [welder] from \the [src].")
		welder = null
		update_icon()
	else
		..()

/obj/item/weldpack/on_update_icon()
	..()

	overlays.Cut()
	if(welder)
		var/image/welder_image = image(welder.icon, icon_state = welder.icon_state)
		welder_image.pixel_x = 16
		overlays += welder_image

/obj/item/weldpack/examine(mob/user)
	. = ..()
	to_chat(user, text("[icon2html(src, user)] [] units of fuel left!", src.reagents.total_volume))

	if(welder)
		to_chat(user, "\The [welder] is attached.")

/obj/item/scrubpack
	name = "scrubber pack"
	desc = "A heavy, unwieldy machine that can filter atmosphere."
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage.dmi'
	icon_state = "scrubpack"
	action_button_name = "Toggle Scrubber"

	var/obj/item/tank/tank
	var/obj/item/cell/cell
	var/tank_permit
	var/list/scrub_names
	var/charge_cost
	var/volume_rate
	var/enabled = FALSE
	var/sound_token

/obj/item/scrubpack/Initialize()
	. = ..()
	if (ispath(tank))
		tank = new tank(src)
	if (ispath(cell))
		cell = new cell(src)
	if (!length(scrub_names))
		scrub_names = list()
		for (var/name in gas_data.gases)
			if (name != GAS_OXYGEN && name != GAS_NITROGEN)
				scrub_names += name

/obj/item/scrubpack/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)
	set_sound_state(FALSE)
	QDEL_NULL(tank)
	QDEL_NULL(cell)

/obj/item/scrubpack/examine(mob/user, distance)
	. = ..()
	if (distance < 5)
		to_chat(user, "It [cell ? "has" : "is missing"] a cell and [tank ? "has" : "is missing"] a tank.")
	if (distance < 2)
		if (tank)
			var/datum/gas_mixture/air = tank.return_air()
			var/kpa = air.return_pressure()  / (TANK_LEAK_PRESSURE * 0.8) * 100
			var/display = "[round(kpa)]%"
			if (user.skill_check(SKILL_ATMOS, SKILL_BASIC))
				switch(kpa)
					if (100 to INFINITY)
						display = "unsafe ([display])"
					if (67 to 100)
						display = "high ([display])"
					if (33 to 67)
						display = "low ([display])"
					else
						display = "very low ([display])"
			to_chat(user, "\The [tank] pressure is [display]")
		if (cell)
			var/display = cell.percent()
			if (user.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
				switch (display)
					if (67 to INFINITY)
						display = "high ([display]%)"
					if (33 to 67)
						display = "medium ([display]%)"
					else
						display = "low ([display]%)"
			else
				display = "[display]%"
			to_chat(user, "\The [cell] charge is [display]")

/obj/item/scrubpack/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/cell))
		if (cell)
			to_chat(user, SPAN_WARNING("\The [src] already has \an [cell]."))
			return TRUE
		if (istype(W, /obj/item/cell/device))
			to_chat(user, SPAN_WARNING("\The [W] is too small for \the [src]."))
			return TRUE
		if (!user.unEquip(W, src))
			return
		user.visible_message(
			SPAN_ITALIC("\The [user] fits \the [W] to \the [src]."),
			SPAN_ITALIC("You fit \the [W] to \the [src]."),
			SPAN_ITALIC("You can hear metal scratching on metal."),
			range = 5
		)
		cell = W
		return TRUE

	if (istype(W, /obj/item/tank))
		if (tank)
			to_chat(user, SPAN_WARNING("\The [src] already has \an [tank]."))
			return TRUE
		if (!istype(W, tank_permit))
			to_chat(user, SPAN_WARNING("\The [src] can't fit \a [W]."))
			return TRUE
		if (!user.unEquip(W, src))
			return
		user.visible_message(
			SPAN_ITALIC("\The [user] fits \the [W] to \the [src]."),
			SPAN_ITALIC("You fit \the [W] to \the [src]."),
			SPAN_ITALIC("You can hear metal scratching on metal."),
			range = 5
		)
		tank = W
		return TRUE

	if (isScrewdriver(W))
		if (enabled)
			to_chat(user, SPAN_WARNING("Turn \the [src] off first!"))
			return TRUE
		if (!cell && !tank)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have anything you can remove."))
			return TRUE
		var/list/options = list()
		if (cell)
			options += "cell"
		if (tank)
			options += "tank"
		var/selection = input("Which would you like to remove?") as null|anything in options
		if (!selection)
			return TRUE
		var/time_cost = 5 - round(user.get_skill_value(SKILL_ATMOS) * 0.5) //0,1,1,2,2
		if (!do_after(user, time_cost SECONDS, src, do_flags = DO_DEFAULT | DO_BOTH_UNIQUE_ACT))
			return TRUE
		var/removed
		if (selection == "cell")
			user.put_in_hands(cell)
			removed = cell
			cell = null
		else if (selection == "tank")
			user.put_in_hands(tank)
			removed = tank
			tank = null
		user.visible_message(
			SPAN_ITALIC("\The [user] removes \the [removed] from \the [src]."),
			SPAN_ITALIC("You remove the [selection] from \the [src]."),
			SPAN_ITALIC("You can hear metal scratching on metal."),
			range = 5
		)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		return TRUE

	. = ..()

/obj/item/scrubpack/attack_self(mob/user)
	toggle(user)

/obj/item/scrubpack/ui_action_click()
	toggle(usr)

/obj/item/scrubpack/proc/set_sound_state(on_off)
	if (on_off)
		sound_token = GLOB.sound_player.PlayLoopingSound(src, "\ref[src]", 'sound/machines/scrubber-active.ogg', 25, 3)
	else
		QDEL_NULL(sound_token)

/obj/item/scrubpack/proc/toggle(mob/user)
	enabled = !enabled
	if (enabled)
		var/list/mods = list()
		if (!cell) mods += "a cell"
		if (!tank) mods += "a tank"
		if (length(mods))
			to_chat(user, SPAN_WARNING("You try to turn on \the [src], but it's missing [english_list(mods)]."))
			enabled = FALSE
			return
		if (cell.charge < charge_cost)
			to_chat(user, SPAN_WARNING("You try to turn on \the [src], but it's out of charge."))
			enabled = FALSE
			return
		to_chat(user, SPAN_ITALIC("You turn on \the [src]."))
		START_PROCESSING(SSobj, src)
		icon_state = "scrubpack_on"
		set_sound_state(TRUE)
	else
		to_chat(user, SPAN_ITALIC("You turn off \the [src]."))
		STOP_PROCESSING(SSobj, src)
		icon_state = "scrubpack"
		set_sound_state(FALSE)

/obj/item/scrubpack/Process()
	var/datum/gas_mixture/tank_air = tank.return_air()
	if (tank_air.return_pressure() > TANK_LEAK_PRESSURE * 0.8)
		audible_message(SPAN_ITALIC("\The [src] beeps stridently and stops working."))
		STOP_PROCESSING(SSobj, src)
		icon_state = "scrubpack"
		set_sound_state(FALSE)
		enabled = FALSE
		return

	var/turf/T = get_turf(src)
	var/datum/gas_mixture/env_air = T.return_air()
	if (env_air.total_moles < MINIMUM_MOLES_TO_FILTER)
		return
	var/transfer_moles = min(1, volume_rate / env_air.volume) * env_air.total_moles
	var/active_scrub_names = scrub_names & env_air.gas
	var/total_filter_moles = 0
	var/list/filter_moles = list()
	for (var/name in active_scrub_names)
		if (env_air.gas[name] < MINIMUM_MOLES_TO_FILTER)
			continue
		filter_moles[name] = env_air.gas[name]
		total_filter_moles += env_air.gas[name]
	if (total_filter_moles < MINIMUM_MOLES_TO_FILTER)
		return

	var/removed = 1
	var/list/final_filter_moles = list()
	while (removed)
		removed = 0
		final_filter_moles = list()
		for (var/name in filter_moles)
			var/amount = filter_moles[name] / total_filter_moles
			if (amount < MINIMUM_MOLES_TO_FILTER)
				filter_moles -= name
				removed = TRUE
				break
			final_filter_moles[name] = amount * transfer_moles

	var/final_cost = max(charge_cost * 0.1, total_filter_moles / volume_rate)
	if (!cell.checked_use(final_cost))
		audible_message(SPAN_ITALIC("\The [src] beeps stridently and stops working."))
		STOP_PROCESSING(SSobj, src)
		icon_state = "scrubpack"
		set_sound_state(FALSE)
		enabled = FALSE
		return

	for (var/name in final_filter_moles)
		tank_air.adjust_gas(name, final_filter_moles[name], update = FALSE)
		env_air.adjust_gas(name, -final_filter_moles[name], update = FALSE)
	tank_air.update_values()
	env_air.update_values()

/obj/item/scrubpack/standard
	cell = /obj/item/cell/standard
	tank = /obj/item/tank/scrubber
	tank_permit = /obj/item/tank/scrubber
	charge_cost = 30
	volume_rate = 150
