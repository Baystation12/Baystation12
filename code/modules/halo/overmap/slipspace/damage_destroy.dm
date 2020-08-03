/*
/obj/machinery/slipspace_engine/ex_act(var/severity)
	return

/obj/machinery/slipspace_engine/Destroy()
	if(om_obj && om_obj.loc == null)
		do_slipspace(pick(block(locate(1,1,GLOB.using_map.overmap_z),locate(GLOB.using_map.overmap_size,GLOB.using_map.overmap_size,GLOB.using_map.overmap_z))))
	. = ..()
*/