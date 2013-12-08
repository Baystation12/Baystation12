
//hacky hack for debugging UC networks
/DebugUC_datum
	var/list/list/nets = list()

/proc/DebugUC(var/client/user)
	if(istype(user))
		var/DebugUC_datum/debug = new()
		debug.nets = all_networks
		user.debug_variables(debug)

/var/list/cardinal8 = list(NORTH, NORTHEAST, NORTHWEST, SOUTH, SOUTHEAST, SOUTHWEST, EAST, WEST)
/var/list/cardinal3d = list(NORTH, SOUTH, EAST, WEST, UP, DOWN)

/obj/var/list/network_number = list()
/obj/var/list/networks = list()

/proc/countUnifiedNetworks()
	var/count = 0
	for(var/key in all_networks)
		var/list/network_list = all_networks[key]
		if(network_list)
			count += network_list.len
	return count

/var/global/defer_cables_rebuild = 0

//3D dir flags - already defined wtf?
//const/UP = 16
//const/DOWN = 32

//hello there 3d code.  welcome to tgcode.  you won't last long.
/proc/get_dir_3d(var/atom/ref, var/atom/target)
	if (get_turf(ref) == get_turf(target))
		return 0
	return get_dir(ref, target) | (target.z > ref.z ? DOWN : 0) | (target.z < ref.z ? UP : 0)

/proc/get_step_3d(atom/ref, dir)
	if(!dir)
		return get_turf(ref)
	if(!dir&(UP|DOWN))
		return get_step(ref,dir)
	//Well, it *did* use temporary vars dx, dy, and dz, but this probably should be as fast as possible
	return locate(ref.x+((dir&EAST)?1:0)-((dir&WEST)?1:0),ref.y+((dir&NORTH)?1:0)-((dir&SOUTH)?1:0),ref.z+((dir&DOWN)?1:0)-((dir&UP)?1:0))

/proc/get_dist_3d(var/atom/Ref, var/atom/Trg)
	return max(abs(Trg.x - Ref.x), abs(Trg.y - Ref.y), abs(Trg.z - Ref.z))

/proc/reverse_dir_3d(dir)
	var/ndir = (dir&NORTH)?SOUTH : 0
	ndir |= (dir&SOUTH)?NORTH : 0
	ndir |= (dir&EAST)?WEST : 0
	ndir |= (dir&WEST)?EAST : 0
	ndir |= (dir&UP)?DOWN : 0
	ndir |= (dir&DOWN)?UP : 0
	return ndir