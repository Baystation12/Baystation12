
/obj/machinery/slipspace_engine/proc/user_slipspace_to_maploc(var/mob/user)
	if(!check_jump_allowed(om_obj.loc))
		return

	var/targ_x = text2num(input(user,"Enter the target location's X value (0 or null to cancel)."))
	if(targ_x == 0 || isnull(targ_x))
		return
	var/targ_y = text2num(input(user,"Enter the target location's Y value (0 or null to cancel)."))
	if(targ_y == 0 || isnull(targ_y))
		return

	overmap_jump_target = locate(targ_x,targ_y,GLOB.using_map.overmap_z)
	if(!overmap_jump_target)
		to_chat(user,"<span class = 'notice'>Invalid coordinates entered for precision jump (1-[world.maxx] by 1-[world.maxy]).</span>")
		return

	overmap_jump_target = get_turf(pick(range(SLIPSPACE_ENGINE_INACCURACY, overmap_jump_target)))

	to_chat(user,"<span class = 'notice'>You start preparing [src] for a slipspace jump...</span>")
	if(!do_after(user, SLIPSPACE_ENGINE_BASE_INTERACTION_DELAY, src, same_direction = 1))
		return
	visible_message("<span class = 'notice'>[user] prepares [src] for a slipspace jump.</span>")

	jump_type = SLIPSPACE_PRECISE
	target_charge_ticks = precision_charge_ticks
	start_charging()
