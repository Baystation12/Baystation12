
/mob/living/simple_animal/hostile/converter_mob
	name = "not bob"
	desc = "your turfs are his turfs now"
	see_invisible = 26
	icon_state = "yithian"
	icon_living = "yithian"
	icon_dead = "yithian_dead"
	ranged = 1
	elevation = 1
	var/list/ignore_types = list() //Faction items like walls, doors, floors should go in here so we don't loop and keep designating our own turfs for conversion.

/mob/living/simple_animal/hostile/converter_mob/ListTargets(var/dist = 8)
	if(istype(loc,/obj/vehicles))
		var/obj/vehicles/v = loc
		dist *= v.vehicle_view_modifier
	var/list/L = list()

	var/turf/loc_infront = get_step(src,dir)

	for(var/atom/A in view(dist,src.loc) | loc_infront.contents)
		var/obj/effect/landmark/build_marker/mark = locate(/obj/effect/landmark/build_marker) in A.contents
		if(mark && mark.build_faction == faction)
			continue
		else
			L += A
	return L

/mob/living/simple_animal/hostile/converter_mob/return_valid_target(var/atom/A)
	if(!(A.type in ignore_types)  && (istype(A,/turf/simulated/wall) || istype(A,/turf/simulated/floor) || istype(A,/obj/machinery/door) || istype(A,/obj/structure/window)))
		stance = HOSTILE_STANCE_ATTACK
		return A
	return null

/mob/living/simple_animal/hostile/converter_mob/SA_attackable(var/targeted)
	if(istype(targeted,/turf/simulated) || istype(targeted,/obj/machinery/door) || istype(targeted,/obj/structure/window))
		return (0)
	return 1

/mob/living/simple_animal/hostile/converter_mob/RangedAttack(var/atom/attacked,var/prox_flag)
	setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	if(SA_attackable(attacked))
		visible_message("<span class = 'notice'>[src] seems confused for a moment, then ignores [attacked]</span>")
		to_chat(src,"<span class = 'notice'>This cannot be marked for conversion.</span>")
		return
	var/build_type = BUILD_MARKER_FLOOR
	var/turf/spawn_loc = attacked
	if(istype(attacked,/turf/simulated/wall))
		build_type = BUILD_MARKER_WALL
	if(istype(attacked,/obj/machinery/door))
		build_type = BUILD_MARKER_DOOR
		spawn_loc = attacked.loc
	if(istype(attacked,/obj/structure/window))
		build_type = BUILD_MARKER_WINDOW
		spawn_loc = attacked.loc

	var/obj/effect/landmark/build_marker/mark = new(spawn_loc)
	var/obj/machinery/door/door = locate() in spawn_loc.contents
	if(door)
		door.open()
	mark.build_faction = faction
	mark.marker_type = build_type
	visible_message("<span class = 'notice'>[src] marks [attacked]</span>")
	target_mob = null

/mob/living/simple_animal/hostile/converter_mob/dbg_forerunner
	name = "Forerunner Designation Drone"
	desc = "A drone designed to designate areas for construction. Usually seen alongside constructors."
	faction = "Forerunner"
	icon = 'code/modules/halo/Forerunner/Sentinel.dmi'
	icon_state = "sentinel"
	icon_living = "sentinel"
	icon_dead = "sentinel_dead"

	ignore_types = list(/turf/simulated/wall/forerunner,/turf/simulated/floor/forerunner_alloy,/obj/machinery/door/unpowered/simple/iron)