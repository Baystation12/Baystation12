
/obj/effect/landmark/sewer_tunnel_thin
	name = "sewer_tunnel_thin"
	icon_state = "x3"
	invisibility = 0
	var/min_length = 5
	var/max_length = 30
	var/max_length_sidetunnels = 10
	var/side_chance = 15
	var/side_tunnel_interval = 5
	var/bumpstairs_room
	var/do_pathing = 1
	var/roomlocs_interval = 20
	var/rat_chance = 0.5
	var/closed_end = 0
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
	var/turf/final_turf
	var/last_side_tunnel = 0

	do
		//world << "	check1"
		cur_turf = get_step(cur_turf, src.dir)
		if(!cur_turf)
			break
		cur_length++

		//tunnel
		var/tunnel_type = /turf/simulated/floor/plating
		if(cur_length == target_length && closed_end)
			tunnel_type = /turf/simulated/wall/tech
		cur_turf.ChangeTurf(tunnel_type)

		//left wall
		var/walltype = /turf/simulated/wall/tech
		if(prob(33))
			walltype = pick(/turf/simulated/mineral, /turf/simulated/floor/plating)
		var/turf/left = get_step(cur_turf,leftdir)
		if(left)
			left.ChangeTurf(walltype)
		else
			break

		//right wall
		walltype = /turf/simulated/wall/tech
		if(prob(33))
			walltype = pick(/turf/simulated/mineral, /turf/simulated/floor/plating)
		var/turf/right = get_step(cur_turf,rightdir)
		if(right)
			right.ChangeTurf(walltype)
		else
			break

		//hostile giant rat
		if(prob(rat_chance))
			var/mob/living/simple_animal/hostile/giant_rat/giant_rat = new(cur_turf)

		//side tunnel
		if(cur_length - last_side_tunnel > side_tunnel_interval)
			if(prob(side_chance))
				var/obj/effect/landmark/sewer_tunnel_thin/side_tunnel = new(loc = cur_turf, generate_now = 0)
				side_tunnel.dir = pick(leftdir, rightdir)
				side_tunnel.max_length = max_length_sidetunnels
				side_tunnel.roomlocs_interval = 2
				side_tunnel.side_chance = 0
				side_tunnel.rat_chance = 10
				roomlocs += side_tunnel.do_path()
				last_side_tunnel = cur_length

		if(cur_length%roomlocs_interval == 0)
			roomlocs[left] = leftdir
			roomlocs[right] = rightdir

		final_turf = cur_turf

	while(cur_length < target_length)

	//remove the diagonal corner tunnel ends
	roomlocs.len -= 2

	//add the end of the tunnel
	//roomlocs[final_turf] = src.dir

	if(bumpstairs_room)
		var/turf/target_turf = pick(roomlocs)
		var/roomdir = roomlocs[target_turf]
		var/obj/effect/landmark/bumpstairs_room/bumpstairs_room = new(target_turf)
		bumpstairs_room.dir = roomdir
		bumpstairs_room.generate_bumpstairs_room()

	qdel(src)

	return roomlocs
