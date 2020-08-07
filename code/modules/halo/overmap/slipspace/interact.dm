
/obj/machinery/slipspace_engine/examine(var/mob/user)
	. = ..()
	if(core_removed)
		to_chat(user,"<span class = 'notice'>[src] has had its core removed and is probably now nonfunctional.</span>")
	else if(core_to_spawn)
		to_chat(user,"<span class = 'info'>Its core can be removed to make a poweful improvised explosive.</span>")

	if(current_charge_ticks)
		to_chat(user,"<span class = 'notice'>[src] is currently [round(100 * current_charge_ticks/target_charge_ticks)]% \
			charged for a jump.</span>")

/obj/machinery/slipspace_engine/allowed(var/mob/user)
	. = ..()
	if(!.)
		src.visible_message("<span class='warning'>[src] flashes a warning: Access Denied.</span>")

/obj/machinery/slipspace_engine/attack_hand(var/mob/user)
	if(!allowed(user))
		return

	if(world.time < ticker.mode.ship_lockdown_until)
		to_chat(user,"<span class = 'notice'>[src] cannot be activated until the ship finalises deployment preparations!</span>")
		return

	if(core_removed)
		to_chat(user,"<span class = 'warning'>[src] has had its core removed, and can no longer be used.</span>")
		return

	if(world.time < next_jump_at)
		var/time_left = round((next_jump_at - world.time) / 10)
		to_chat(user,"<span class = 'warning'>[src] is still cooling down from the previous jump \
			([time_left] seconds left).</span>")
		return

	if(!om_obj)
		om_obj = map_sectors["[src.z]"]
	if(!om_obj)
		to_chat(user,"<span class = 'warning'>[src] is unable to locate host ship.</span>")
		return

	if(current_charge_ticks)
		var/desc
		if(current_charge_ticks >= target_charge_ticks)
			desc = "[src] is ready to activate slipspace jump."
		else
			desc = "[src] is still charging up for slipspace jump."

		var/chosen = alert(desc, "Slipspace jump", "Cancel Charging", \
			current_charge_ticks >= target_charge_ticks ? "Activate" : "Continue Charging")
		if(chosen == "Activate")
			do_jump()
		else if(chosen == "Cancel Charging")
			stop_charging()

	else if(powered())
		var/list/options = list("Exit the system","Emergency short range jump"/*,"Overload"*/)
		if(precise_jump)
			options += "Precision short range jump"
		if(core_to_spawn)
			options += "Extract core for mobile detonation"
		var/chosen = input("[src] is ready to charge", "Slipspace jump", null) as null|anything in options

		if(chosen == "Exit the system")
			user_slipspace_to_nullspace(user)

		else if(chosen == "Emergency short range jump")
			user_slipspace_emergency(user)

		else if(chosen == "Precision short range jump")
			user_slipspace_to_maploc(user)

		else if(chosen == "Overload")
			user_overload_engine(user)

		else if(chosen == "Extract core for mobile detonation")
			user_remove_core(user)
	else
		to_chat(user,"<span class='warning'>[src] is unpowered.</span>")
