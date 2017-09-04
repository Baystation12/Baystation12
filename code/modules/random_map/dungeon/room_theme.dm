//room theme is basically the turfs that which a dungeon defaults to making a room out of.
/datum/room_theme
	var/wall_type
	var/floor_type
	var/door_type = /obj/machinery/door/unpowered/simple/iron
	var/xorigin = 1
	var/yorigin = 1
	var/zorigin = 1
	var/lock_complexity_min = 0
	var/lock_complexity_max = 0
	var/lock_data
	var/layout_chance = 50//chance of having a lyout period
	var/list/room_layouts = list()

/datum/room_theme/New(var/x,var/y,var/z)
	xorigin = x
	yorigin = y
	zorigin = z
	if(!lock_data && lock_complexity_max > 0)
		lock_data = generateRandomString(rand(lock_complexity_min,lock_complexity_max))

/datum/room_theme/proc/apply_room_theme(var/x,var/y,var/value)
	var/turf/T = locate(x,y,zorigin)
	if(!T)
		return 0
	var/path
	switch(value)
		if(WALL_CHAR)
			if(!wall_type)
				return
			path = wall_type
		if(ARTIFACT_TURF_CHAR)
			if(!wall_type)
				return
			path = wall_type
		else
			if(!floor_type)
				return
			path = floor_type
	T.ChangeTurf(path)

/datum/room_theme/proc/apply_room_door(var/x,var/y)
	if(!door_type)
		return 0
	var/turf/T = locate(xorigin+x-1,yorigin+y-1,zorigin)
	for(var/i = -1; i <= 1; i++)
		for(var/j = -1; j <= 1; j++)
			var/turf/check = locate(T.x + i, T.y + j, T.z)
			if(!check)
				continue
			for(var/atom/movable/M in check.contents)
				if(!istype(M, /atom/movable/lighting_overlay) && M.density)
					return 0
	if(!T)
		return 0
	if(ispath(door_type,/obj/machinery/door/unpowered/simple))
		new door_type(T,null,lock_data)
	else
		new door_type(T)

/datum/room_theme/proc/get_a_room_layout()
	if(room_layouts.len && prob(layout_chance))
		return pickweight(room_layouts)
	return null

/datum/room_theme/metal
	wall_type = /turf/simulated/wall
	floor_type = /turf/simulated/floor/plating
	lock_complexity_max = 2
	layout_chance = 30
	room_layouts = list(/datum/random_room/mimic = 1, /datum/random_room/tomb = 1)

/datum/room_theme/metal/secure
	layout_chance = 100
	lock_complexity_min = 2
	lock_complexity_max = 5