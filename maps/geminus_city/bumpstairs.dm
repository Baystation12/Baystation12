
/obj/structure/bumpstairs
	name = "stairs"
	desc = "On and on and on, they lead somewhere else..."
	density = 0
	anchored = 1
	icon = 'citymap_icons/ramps.dmi'
	icon_state = "rampbottom"
	var/id_self
	var/id_target

/obj/structure/bumpstairs/New()
	. = ..()

	var/obj/effect/bump_teleporter/bump = new(src.loc)
	bump.id = id_self
	bump.id_target = id_target

/obj/structure/bumpstairs/sewers_one
	id_self = "sewers1"
	id_target = "innie1"

/obj/structure/bumpstairs/sewers_two
	id_self = "sewers2"
	id_target = "innie2"

/obj/structure/bumpstairs/sewers_three
	id_self = "sewers3"
	id_target = "innie3"

/obj/effect/landmark/bumpstairs_room
	name = "bumpstairs_room_one"
	icon_state = "x2"
	invisibility = 101
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
