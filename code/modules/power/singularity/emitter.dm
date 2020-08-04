#define EMITTER_DAMAGE_POWER_TRANSFER 450 //used to transfer power to containment field generators

/obj/machinery/power/emitter
	name = "emitter"
	desc = "A massive heavy industrial laser. This design is a fixed installation, capable of shooting in only one direction."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	anchored = 0
	density = 1
	req_access = list(access_engine_equip)
	active_power_usage = 100 KILOWATTS

	var/efficiency = 0.3	// Energy efficiency. 30% at this time, so 100kW load means 30kW laser pulses.
	var/active = 0
	var/powered = 0
	var/fire_delay = 100
	var/max_burst_delay = 100
	var/min_burst_delay = 20
	var/burst_shots = 3
	var/last_shot = 0
	var/shot_number = 0
	var/state = 0
	var/locked = 0
	core_skill = SKILL_ENGINES

	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/radio/receiver,
		/obj/item/weapon/stock_parts/power/apc
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
	anchored = 1
	state = 2

/obj/machinery/power/emitter/Initialize()
	. = ..()
	if(state == 2 && anchored)
		connect_to_network()

/obj/machinery/power/emitter/Destroy()
	log_and_message_admins("deleted \the [src]")
	investigate_log("<font color='red'>deleted</font> at ([x],[y],[z])","singulo")
	return ..()

/obj/machinery/power/emitter/on_update_icon()
	if (active && powernet && avail(active_power_usage))
		icon_state = "emitter_+a"
	else
		icon_state = "emitter"

/obj/machinery/power/emitter/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	activate(user)
	return TRUE

/obj/machinery/power/emitter/proc/activate(mob/user as mob)
	if(!istype(user))
		user = null // safety, as the proc is publicly available.

	if(state == 2)
		if(!powernet)
			to_chat(user, "\The [src] isn't connected to a wire.")
			return 1
		if(!src.locked)
			if(src.active==1)
				src.active = 0
				to_chat(user, "You turn off \the [src].")
				log_and_message_admins("turned off \the [src]")
				investigate_log("turned <font color='red'>off</font> by [key_name_admin(user || usr)]","singulo")
			else
				src.active = 1
				if(user)
					operator_skill = user.get_skill_value(core_skill)
				update_efficiency()
				to_chat(user, "You turn on \the [src].")
				src.shot_number = 0
				src.fire_delay = get_initial_fire_delay()
				log_and_message_admins("turned on \the [src]")
				investigate_log("turned <font color='green'>on</font> by [key_name_admin(user || usr)]","singulo")
			update_icon()
		else
			to_chat(user, "<span class='warning'>The controls are locked!</span>")
	else
		to_chat(user, "<span class='warning'>\The [src] needs to be firmly secured to the floor first.</span>")
		return 1

/obj/machinery/power/emitter/proc/update_efficiency()
	efficiency = initial(efficiency)
	if(!operator_skill)
		return
	var/skill_modifier = 0.8 * (SKILL_MAX - operator_skill)/(SKILL_MAX - SKILL_MIN) //How much randomness is added
	efficiency *= 1 + (rand() - 1) * skill_modifier //subtract off between 0.8 and 0, depending on skill and luck.

/obj/machinery/power/emitter/emp_act(var/severity)
	return 1

/obj/machinery/power/emitter/Process()
	if(stat & (BROKEN))
		return
	if(src.state != 2 || (!powernet && active_power_usage))
		src.active = 0
		update_icon()
		return
	if(((src.last_shot + src.fire_delay) <= world.time) && (src.active == 1))

		var/actual_load = draw_power(active_power_usage)
		if(actual_load >= active_power_usage) //does the laser have enough power to shoot?
			if(!powered)
				powered = 1
				update_icon()
				investigate_log("regained power and turned <font color='green'>on</font>","singulo")
		else
			if(powered)
				powered = 0
				update_icon()
				investigate_log("lost power and turned <font color='red'>off</font>","singulo")
			return

		src.last_shot = world.time
		if(src.shot_number < burst_shots)
			src.fire_delay = get_burst_delay()
			src.shot_number ++
		else
			src.fire_delay = get_rand_burst_delay()
			src.shot_number = 0

		//need to calculate the power per shot as the emitter doesn't fire continuously.
		var/burst_time = (min_burst_delay + max_burst_delay)/2 + 2*(burst_shots-1)
		var/power_per_shot = (active_power_usage * efficiency) * (burst_time/10) / burst_shots

		if(prob(35))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, src)
			s.start()

		var/obj/item/projectile/beam/emitter/A = get_emitter_beam()
		playsound(src.loc, A.fire_sound, 25, 1)
		A.damage = round(power_per_shot/EMITTER_DAMAGE_POWER_TRANSFER)
		A.launch( get_step(src.loc, src.dir) )

/obj/machinery/power/emitter/attackby(obj/item/W, mob/user)

	if(isWrench(W))
		if(active)
			to_chat(user, "Turn off [src] first.")
			return
		switch(state)
			if(0)
				state = 1
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures [src] to the floor.", \
					"You secure the external reinforcing bolts to the floor.", \
					"You hear a ratchet")
				src.anchored = 1
			if(1)
				state = 0
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures [src] reinforcing bolts from the floor.", \
					"You undo the external reinforcing bolts.", \
					"You hear a ratchet")
				src.anchored = 0
			if(2)
				to_chat(user, "<span class='warning'>\The [src] needs to be unwelded from the floor.</span>")
		return

	if(isWelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		if(active)
			to_chat(user, "Turn off [src] first.")
			return
		switch(state)
			if(0)
				to_chat(user, "<span class='warning'>\The [src] needs to be wrenched to the floor.</span>")
			if(1)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to weld [src] to the floor.", \
						"You start to weld [src] to the floor.", \
						"You hear welding")
					if (do_after(user,20,src))
						if(!src || !WT.isOn()) return
						state = 2
						to_chat(user, "You weld [src] to the floor.")
						connect_to_network()
				else
					to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
			if(2)
				if (WT.remove_fuel(0,user))
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message("[user.name] starts to cut [src] free from the floor.", \
						"You start to cut [src] free from the floor.", \
						"You hear welding")
					if (do_after(user,20,src))
						if(!src || !WT.isOn()) return
						state = 1
						to_chat(user, "You cut [src] free from the floor.")
						disconnect_from_network()
				else
					to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
		return

	if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/modular_computer))
		if(emagged)
			to_chat(user, "<span class='warning'>The lock seems to be broken.</span>")
			return
		if(src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	..()
	return

/obj/machinery/power/emitter/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		locked = 0
		emagged = 1
		req_access.Cut()
		user.visible_message("[user.name] emags [src].","<span class='warning'>You short out the lock.</span>")
		return 1

/obj/machinery/power/emitter/proc/get_initial_fire_delay()
	return 100

/obj/machinery/power/emitter/proc/get_rand_burst_delay()
	return rand(min_burst_delay, max_burst_delay)

/obj/machinery/power/emitter/proc/get_burst_delay()
	return 2

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