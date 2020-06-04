
//see code/modules/halo/misc/bumpstairs.dm
//and code/modules/halo/misc/bumpstairs_sewer.dm

/obj/effect/landmark/bumpstairs_room
	name = "bumpstairs_room_one"
	icon_state = "x2"
	var/bumpstairs_type = /obj/structure/bumpstairs/sewers_one

/obj/effect/landmark/bumpstairs_room/one

/obj/effect/landmark/bumpstairs_room/two
	name = "bumpstairs_room_two"
	bumpstairs_type = /obj/structure/bumpstairs/sewers_two

/obj/effect/landmark/bumpstairs_room/three
	name = "bumpstairs_room_three"
	bumpstairs_type = /obj/structure/bumpstairs/sewers_three

/obj/effect/landmark/bumpstairs_room/proc/generate_bumpstairs_room()
	var/roomdir = src.dir
	var/turf/cur_turf = get_turf(src)
	var/turf/nextturf

	var/leftdir = turn(roomdir, -90)
	var/rightdir = turn(roomdir, 90)

	cur_turf.ChangeTurf(/turf/simulated/wall/tech/fake)
	cur_turf:faction_locked = "Insurrection"
	cur_turf.dir = roomdir
	nextturf = get_step(cur_turf,leftdir)
	nextturf.ChangeTurf(/turf/simulated/wall/tech)
	nextturf = get_step(cur_turf,rightdir)
	nextturf.ChangeTurf(/turf/simulated/wall/tech)

	cur_turf = get_step(cur_turf, roomdir)

	cur_turf.ChangeTurf(/turf/simulated/floor/plating)
	nextturf = get_step(cur_turf,leftdir)
	nextturf.ChangeTurf(/turf/simulated/mineral/planet)
	nextturf = get_step(cur_turf,rightdir)
	nextturf.ChangeTurf(/turf/simulated/mineral/planet)
	//
	var/obj/structure/bumpstairs/mystairs = new bumpstairs_type(cur_turf)
	mystairs.dir = turn(roomdir, 180)
	//
	var/obj/machinery/light/small/S = new(cur_turf)
	S.dir = roomdir
	S.seton(0)

	cur_turf = get_step(cur_turf, roomdir)

	cur_turf.ChangeTurf(/turf/simulated/mineral/planet)
	nextturf = get_step(cur_turf,leftdir)
	nextturf.ChangeTurf(/turf/simulated/wall/tech)
	nextturf = get_step(cur_turf,rightdir)
	nextturf.ChangeTurf(/turf/simulated/wall/tech)

	qdel(src)
