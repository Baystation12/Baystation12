
/obj/machinery/slipspace_engine/proc/user_slipspace_emergency(var/mob/user)
	overmap_jump_target = null

	//centre of the map
	var/new_x = GLOB.using_map.overmap_size / 2
	var/new_y = GLOB.using_map.overmap_size / 2

	//move to opposite x half with a random offset
	var/x_offset = rand(world.view, GLOB.using_map.overmap_size / 2 - world.view)
	if(om_obj.x < new_x)
		new_x += x_offset
	else
		new_x -= x_offset

	//move to opposite y half with a random offset
	var/y_offset = rand(world.view, GLOB.using_map.overmap_size / 2 - world.view)
	if(om_obj.y < new_y)
		new_y += y_offset
	else
		new_y -= y_offset

	//get the turf
	overmap_jump_target = locate(new_x, new_y, om_obj.z)

	if(overmap_jump_target)
		jump_type = SLIPSPACE_EMERGENCY
		target_charge_ticks = emergency_charge_ticks
		start_charging()
		visible_message("<span class = 'notice'>[user] prepares [src] for a jump to slipspace.</span>")
	else
		to_chat(user,"<span class='info'>Emergency slipspace failed: unable to locate destination. Please try again.</span>")
		to_debug_listeners("Emergency jump failed to find target for [user] with ckey [user.ckey] and [src.type]")
