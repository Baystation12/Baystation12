
/obj/effect/landmark/sewer_tunnel_thin
	name = "sewer_tunnel_thin"
	icon_state = "x3"
	invisibility = 0
	var/min_length = 5
	var/max_length = 30
	var/max_length_sidetunnels = 10
	var/side_chance = 15
	var/side_tunnel_interval = 5
	var/bumpstairs_room_type
	var/do_pathing = 1
	var/roomlocs_interval = 20
	var/animal_chance = 0.5
	var/list/hostile_animal_types = list(\
		/mob/living/simple_animal/hostile/giant_rat,\
		/mob/living/simple_animal/hostile/alligator)
	var/closed_end = 0
	var/light_intervals = 6
	var/list/roomlocs = list()

/obj/effect/landmark/sewer_tunnel_thin/New(var/loc, var/generate_now = 1)
	do_pathing = generate_now
	. = ..()

/obj/effect/landmark/sewer_tunnel_thin/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/sewer_tunnel_thin/LateInitialize()
	. = ..()
	if(do_pathing)
		do_path()

/obj/effect/landmark/sewer_tunnel_thin/proc/do_path()
	//set background = 1

	var/turf/cur_turf = get_turf(src)
	var/leftdir = turn(src.dir, 90)
	var/rightdir = turn(src.dir, -90)
	var/cur_length = 0
	var/target_length = rand(min_length, max_length)
	var/last_side_tunnel = 0

	do
		cur_turf = get_step(cur_turf, src.dir)
		if(!cur_turf)
			break
		cur_length++

		//tunnel
		var/tunnel_type = /turf/simulated/floor/plating
		if(prob(20))
			tunnel_type = /turf/simulated/floor/water/shallow
		if(cur_length == target_length && closed_end)
			tunnel_type = /turf/simulated/wall/tech
		cur_turf.ChangeTurf(tunnel_type)

		var/list/lightdirs = list()

		//left wall
		var/walltype = /turf/simulated/wall/tech
		if(prob(33))
			walltype = pick(/turf/simulated/mineral, /turf/simulated/floor/plating, /turf/simulated/floor/water)
		else if(cur_length % light_intervals == 0)
			//check if we can place a light here
			lightdirs.Add(leftdir)

		var/turf/left = get_step(cur_turf,leftdir)
		if(left)
			left.ChangeTurf(walltype)
		else
			break

		//right wall
		walltype = /turf/simulated/wall/tech
		if(prob(33))
			walltype = pick(/turf/simulated/mineral, /turf/simulated/floor/plating, /turf/simulated/floor/water, /turf/simulated/floor/water/shallow)
		else if(cur_length % light_intervals == 0)
			//check if we can place a light here
			lightdirs.Add(rightdir)

		var/turf/right = get_step(cur_turf,rightdir)
		if(right)
			right.ChangeTurf(walltype)
		else
			break

		//hostile NPC animal
		if(prob(animal_chance))
			var/animal_type = pick(hostile_animal_types)

			var/mob/living/simple_animal/hostile/animal = new animal_type(cur_turf)
			animal.faction = "Insurrection"
			animal.respawning = 1

		//side tunnel
		if(cur_length - last_side_tunnel > side_tunnel_interval)
			if(prob(side_chance))
				var/obj/effect/landmark/sewer_tunnel_thin/side_tunnel = new(loc = cur_turf, generate_now = 0)
				side_tunnel.dir = pick(leftdir, rightdir)
				side_tunnel.max_length = max_length_sidetunnels
				side_tunnel.roomlocs_interval = 2
				side_tunnel.side_chance = 0
				side_tunnel.animal_chance = 10
				roomlocs += side_tunnel.do_path()
				last_side_tunnel = cur_length

		//generate a light?
		if(lightdirs.len)
			var/obj/machinery/light/small/S = new(cur_turf)
			S.dir = pick(lightdirs)

		//check if this is a possible spot to put a bumpstairs room
		if(cur_length%roomlocs_interval == 0)
			roomlocs[left] = leftdir
			roomlocs[right] = rightdir

	while(cur_length < target_length)

	//remove the diagonal corner tunnel ends
	roomlocs.len -= 2

	if(bumpstairs_room_type)
		var/turf/target_turf = pick(roomlocs)
		var/roomdir = roomlocs[target_turf]
		var/obj/effect/landmark/bumpstairs_room/my_room = new bumpstairs_room_type(target_turf)
		my_room.dir = roomdir
		my_room.generate_bumpstairs_room()

	qdel(src)

	return roomlocs
