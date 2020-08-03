//icon_state = "slipspace_overheat"

/obj/machinery/slipspace_engine/proc/overload_engine(var/mob/user)
/*
	jump_charging = -1
	src.density = 0
	var/obj/core = new core_to_spawn(loc)
	icon_state = "[initial(icon_state)]_coreremoved"
	core.attack_hand(user)
	*/

/obj/machinery/slipspace_engine/proc/user_overload_engine(var/mob/user)
/*
	if(isnull(core_to_spawn))
		to_chat(user,"<span class = 'notice'>Physical limiters disallow core overloading on [src]</span>")
		return
	visible_message("<span class = 'danger'>[user] starts prepping [src] for mobile core detonation...</span>")
	if(!do_after(user, SLIPSPACE_ENGINE_BASE_INTERACTION_DELAY * 3, src, same_direction = 1))
		return
	visible_message("<span class = 'danger'>[user] preps [src] for mobile core detonation..</span>")
	message2discord(config.oni_discord, "Alert: [user.real_name] ([user.ckey]) has overloaded the slipspace engine @ ([loc.x],[loc.y],[loc.z])")
	overload_engine(user)
*/