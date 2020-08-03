
//a "road" is a series of bumpstairs in a line to link two maps together
//this code automatically generates and links bump teleporters across two map levels
//the map levels do not need to be linked in the overmap unlike stairs and ladders
//this is effectively a "horizontal" connection across multiz, whereas stairs and ladders are vertical

//see code/modules/halo/misc/bumpstairs.dm

/obj/structure/bumpstairs/road
	var/spread_max = 9
	var/spread_dir = EAST
	opacity = 1

/obj/structure/bumpstairs/road/New(var/loc, var/new_spread_dir = spread_dir, var/new_spread_max = spread_max, var/new_dir = dir, var/number = 1, var/list/new_blocked_types)
	id_self = "[id_self][number]"
	id_target = "[id_target][number]"

	spread_max = new_spread_max
	spread_dir = new_spread_dir

	dir = new_dir

	if(new_blocked_types && new_blocked_types.len)
		blocked_types = new_blocked_types

	//setup the bump tele linking
	. = ..()

	if(number < spread_max)
		var/turf/cur_turf = get_turf(src)
		var/turf/next_turf = get_step(cur_turf, spread_dir)
		if(next_turf)
			new src.type(next_turf, new_spread_dir, new_spread_max, dir, number + 1, blocked_types)
