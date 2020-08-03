
/obj/machinery/slipspace_engine/proc/user_slipspace_to_nullspace(var/mob/user)
	if(!check_jump_allowed(om_obj.loc))
		return

	to_chat(user,"<span class = 'notice'>You start preparing [src] for a slipspace jump...</span>")
	if(!do_after(user, SLIPSPACE_ENGINE_BASE_INTERACTION_DELAY, src, same_direction = 1))
		return
	visible_message("<span class = 'notice'>[user] prepares [src] for a jump to slipspace.</span>")
	//log_admin("[user] the [user.mind.assigned_role] (CKEY: [user.ckey]) activated a slipspace engine, transporting [om_obj] to nullspace.")

	overmap_jump_target = null
	jump_type = SLIPSPACE_LONG
	target_charge_ticks = long_charge_ticks
	start_charging()
