#define EMITTER_DAMAGE_POWER_TRANSFER 450 //used to transfer power to containment field generators

/obj/machinery/power/emitter
	name = "emitter"
	desc = "A massive, heavy-duty industrial laser. This design is a fixed installation, capable of shooting in only one direction."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	anchored = FALSE
	density = TRUE
	active_power_usage = 100 KILOWATTS
	obj_flags = OBJ_FLAG_ROTATABLE

	/// Access required to lock or unlock the emitter. Separate variable to prevent `req_access` from blocking use of the emitter while unlocked.
	var/list/req_lock_access = list(access_engine_equip)
	var/efficiency = 0.3	// Energy efficiency. 30% at this time, so 100kW load means 30kW laser pulses.
	var/active = FALSE
	var/powered = FALSE
	var/fire_delay = 10 SECONDS
	var/max_burst_delay = 10 SECONDS
	var/min_burst_delay = 2 SECONDS
	var/burst_shots = 3
	var/last_shot = 0
	var/shot_number = 0
	var/state = EMITTER_LOOSE
	var/locked = FALSE
	core_skill = SKILL_ENGINES

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	public_variables = list(
		/decl/public_access/public_variable/emitter_active,
		/decl/public_access/public_variable/emitter_locked
	)
	public_methods = list(
		/decl/public_access/public_method/toggle_emitter
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/emitter = 1)

/obj/machinery/power/emitter/anchored
	anchored = TRUE
	state = EMITTER_WELDED

/obj/machinery/power/emitter/anchored/on
	active = TRUE
	powered = TRUE

/obj/machinery/power/emitter/Initialize()
	. = ..()
	if (state == EMITTER_WELDED && anchored)
		connect_to_network()

/obj/machinery/power/emitter/Destroy()
	log_and_message_admins("deleted \the [src]")
	investigate_log("<font color='red'>deleted</font> at ([x],[y],[z])","singulo")
	return ..()

/obj/machinery/power/emitter/examine(mob/user)
	. = ..()
	var/is_observer = isobserver(user)
	if (user.Adjacent(src) || is_observer)
		var/state_message = "It is unsecured."
		switch (state)
			if (EMITTER_WRENCHED)
				state_message = "It is bolted to the floor, but lacks securing welds."
			if (EMITTER_WELDED)
				state_message = "It is firmly secured in place."
		to_chat(user, SPAN_NOTICE(state_message))
		if (emagged && (user.skill_check(core_skill, SKILL_ADEPT) || is_observer))
			to_chat(user, SPAN_WARNING("Its control locks have been fried."))

/obj/machinery/power/emitter/on_update_icon()
	if (active && powernet && avail(active_power_usage))
		icon_state = "emitter_+a"
	else
		icon_state = "emitter"

/obj/machinery/power/emitter/interface_interact(mob/user)
	if (!CanInteract(user, DefaultTopicState()))
		return FALSE
	activate(user)
	return TRUE

/obj/machinery/power/emitter/proc/activate(mob/user as mob)
	if (!istype(user))
		user = null // safety, as the proc is publicly available.

	if (state == EMITTER_WELDED)
		if (!powernet)
			to_chat(user, SPAN_WARNING("You try to turn on \the [src], but it doesn't seem to be receiving power."))
			return TRUE
		if (!locked)
			var/area/A = get_area(src)
			if (active)
				active = FALSE
				if (user?.Adjacent(src))
					user.visible_message(
						SPAN_NOTICE("\The [user] turns off \the [src]."),
						SPAN_NOTICE("You power down \the [src]."),
						SPAN_ITALIC("You hear a switch being flicked.")
					)
				else
					visible_message(SPAN_NOTICE("\The [src] turns off."))
				playsound(src, "switch", 50)
				log_and_message_admins("turned off \the [src] in [A.name]", user, src)
				investigate_log("turned <font color='red'>off</font> by [key_name_admin(user || usr)] in [A.name]","singulo")
			else
				active = TRUE
				if (user)
					operator_skill = user.get_skill_value(core_skill)
				if (user?.Adjacent(src))
					user.visible_message(
						SPAN_NOTICE("\The [user] turns on \the [src]."),
						SPAN_NOTICE("You configure \the [src] and turn it on."), // Mention configuration to allude to operator skill playing into efficiency
						SPAN_ITALIC("You hear a switch being flicked.")
					)
				else
					visible_message(SPAN_NOTICE("\The [src] turns on."))
				playsound(src, "switch", 50)
				update_efficiency()
				shot_number = 0
				fire_delay = get_initial_fire_delay()
				log_and_message_admins("turned on \the [src] in [A.name]", user, src)
				investigate_log("turned <font color='green'>on</font> by [key_name_admin(user || usr)] in [A.name]","singulo")
			update_icon()
		else
			to_chat(user, SPAN_WARNING("The controls are locked!"))
	else
		to_chat(user, SPAN_WARNING("\The [src] needs to be firmly secured to the floor first."))
		return TRUE

/obj/machinery/power/emitter/proc/update_efficiency()
	efficiency = initial(efficiency)
	if (!operator_skill)
		return
	var/skill_modifier = 0.8 * (SKILL_MAX - operator_skill)/(SKILL_MAX - SKILL_MIN) //How much randomness is added
	efficiency *= 1 + (rand() - 1) * skill_modifier //subtract off between 0.8 and 0, depending on skill and luck.

/obj/machinery/power/emitter/emp_act(var/severity)
	return

/obj/machinery/power/emitter/Process()
	if (stat & (BROKEN))
		return
	if (state != EMITTER_WELDED || (!powernet && active_power_usage))
		active = FALSE
		update_icon()
		return
	if (((last_shot + fire_delay) <= world.time) && active)

		var/actual_load = draw_power(active_power_usage)
		if (actual_load >= active_power_usage) // does the laser have enough power to shoot?
			if (!powered)
				powered = TRUE
				update_icon()
				visible_message(SPAN_WARNING("\The [src] powers up!"))
				investigate_log("regained power and turned <font color='green'>on</font>","singulo")
		else
			if (powered)
				powered = FALSE
				update_icon()
				visible_message(SPAN_WARNING("\The [src] powers down!"))
				investigate_log("lost power and turned <font color='red'>off</font>","singulo")
			return

		last_shot = world.time
		if (shot_number < burst_shots)
			fire_delay = get_burst_delay()
			shot_number++
		else
			fire_delay = get_rand_burst_delay()
			shot_number = 0

		//need to calculate the power per shot as the emitter doesn't fire continuously.
		var/burst_time = (min_burst_delay + max_burst_delay) / 2 + 2 * (burst_shots - 1)
		var/power_per_shot = (active_power_usage * efficiency) * (burst_time / 10) / burst_shots

		if (prob(35))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, src)
			s.start()

		var/obj/item/projectile/beam/emitter/A = get_emitter_beam()
		playsound(loc, A.fire_sound, 25, TRUE)
		A.damage = round (power_per_shot / EMITTER_DAMAGE_POWER_TRANSFER)
		A.launch( get_step(loc, dir) )

/obj/machinery/power/emitter/attackby(obj/item/W, mob/user)

	if (isWrench(W))
		if (active)
			to_chat(user, SPAN_WARNING("Turn \the [src] off first."))
			return
		switch(state)
			if (EMITTER_LOOSE)
				state = EMITTER_WRENCHED
				playsound(loc, 'sound/items/Ratchet.ogg', 75, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] secures \the [src] to the floor."),
					SPAN_NOTICE("You drop the external reinforcing bolts and secure them to the floor."),
					SPAN_ITALIC("You hear ratcheting.")
				)
				anchored = TRUE
			if (EMITTER_WRENCHED)
				state = EMITTER_LOOSE
				playsound(loc, 'sound/items/Ratchet.ogg', 75, TRUE)
				user.visible_message(
					SPAN_NOTICE("\The [user] unsecures \the [src] from the floor."),
					SPAN_NOTICE("You undo the external reinforcing bolts."),
					SPAN_ITALIC("You hear ratcheting.")
				)
				anchored = FALSE
			if (EMITTER_WELDED)
				to_chat(user, SPAN_WARNING("\The [src] needs to be unwelded from the floor before you raise its bolts."))
		return

	if (isWelder(W))
		var/obj/item/weldingtool/WT = W
		if (active)
			to_chat(user, SPAN_WARNING("Turn \the [src] off first."))
			return
		switch(state)
			if (EMITTER_LOOSE)
				to_chat(user, SPAN_WARNING("\The [src] needs to be wrenched to the floor."))
			if (EMITTER_WRENCHED)
				if (WT.remove_fuel(0, user))
					playsound(loc, 'sound/items/Welder.ogg', 50, TRUE)
					user.visible_message(
						SPAN_NOTICE("\The [user] starts to weld \the [src] to the floor."),
						SPAN_NOTICE("You start to weld \the [src] to the floor."),
						SPAN_ITALIC("You hear welding.")
					)
					if (do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
						if (!WT.isOn())
							return
						state = EMITTER_WELDED
						playsound(loc, 'sound/items/Welder2.ogg', 50, TRUE)
						user.visible_message(
							SPAN_NOTICE("\The [user] welds \the [src] to the floor."),
							SPAN_NOTICE("You weld the base of \the [src] to the floor, securing it in place."),
							SPAN_ITALIC("You hear welding.")
						)
						connect_to_network()
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			if (EMITTER_WELDED)
				if (WT.remove_fuel(0, user))
					playsound(loc, 'sound/items/Welder.ogg', 50, TRUE)
					user.visible_message(
						SPAN_NOTICE("\The [user] starts to cut \the [src] free from the floor."),
						SPAN_NOTICE("You start to cut \the [src] free from the floor."),
						SPAN_ITALIC("You hear welding.")
					)
					if (do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE))
						if (!WT.isOn())
							return
						state = EMITTER_WRENCHED
						playsound(loc, 'sound/items/Welder2.ogg', 50, TRUE)
						user.visible_message(
							SPAN_NOTICE("\The [user] cuts \the [src] free from the floor."),
							SPAN_NOTICE("You cut \the [src] free from the floor."),
							SPAN_ITALIC("You hear welding.")
						)
						disconnect_from_network()
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return

	if (istype(W, /obj/item/card/id) || istype(W, /obj/item/modular_computer))
		if (emagged)
			to_chat(user, SPAN_WARNING("The control lock seems to be broken."))
			return
		if (has_access(req_lock_access, W.GetAccess()))
			locked = !locked
			user.visible_message(
				SPAN_NOTICE("\The [user] [locked ? "locks" : "unlocks"] \the [src]'s controls."),
				SPAN_NOTICE("You [locked ? "lock" : "unlock"] the controls.")
			)
		else
			to_chat(user, SPAN_WARNING("\The [src]'s controls flash an 'Access denied' warning."))
		return
	..()
	return

/obj/machinery/power/emitter/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		locked = FALSE
		emagged = TRUE
		req_access.Cut()
		req_lock_access.Cut()
		user.visible_message(SPAN_WARNING("\The [user] messes with \the [src]'s controls."), SPAN_WARNING("You short out the control lock."))
		user.playsound_local(loc, "sparks", 50, TRUE)
		return TRUE

/obj/machinery/power/emitter/proc/get_initial_fire_delay()
	return 10 SECONDS

/obj/machinery/power/emitter/proc/get_rand_burst_delay()
	return rand(min_burst_delay, max_burst_delay)

/obj/machinery/power/emitter/proc/get_burst_delay()
	return 0.2 SECONDS // This value doesn't really affect normal emitters, but *does* affect subtypes like the gyrotron that can have very long delays

/obj/machinery/power/emitter/proc/get_emitter_beam()
	return new /obj/item/projectile/beam/emitter(get_turf(src))

/decl/public_access/public_method/toggle_emitter
	name = "toggle emitter"
	desc = "Toggles whether or not the emitter is active. It must be unlocked to work."
	call_proc = /obj/machinery/power/emitter/proc/activate

/decl/public_access/public_variable/emitter_active
	expected_type = /obj/machinery/power/emitter
	name = "emitter active"
	desc = "Whether or not the emitter is firing."
	can_write = FALSE
	has_updates = FALSE

/decl/public_access/public_variable/emitter_active/access_var(obj/machinery/power/emitter/emitter)
	return emitter.active

/decl/public_access/public_variable/emitter_locked
	expected_type = /obj/machinery/power/emitter
	name = "emitter locked"
	desc = "Whether or not the emitter is locked. Being locked prevents one from changing the active state."
	can_write = FALSE
	has_updates = FALSE

/decl/public_access/public_variable/emitter_locked/access_var(obj/machinery/power/emitter/emitter)
	return emitter.locked

/decl/stock_part_preset/radio/receiver/emitter
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /decl/public_access/public_method/toggle_emitter)
