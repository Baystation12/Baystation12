
#define BUILD_MARKER_WALL 1
#define BUILD_MARKER_FLOOR 2
#define BUILD_MARKER_DOOR 3
#define BUILD_MARKER_WINDOW 4

/obj/effect/landmark/build_marker
	name = "Build Marker"
	desc = "Marks a location to have something built."
	invisibility = 26 //1 above the norm
	var/marker_type = BUILD_MARKER_WALL
	var/build_faction = "hostile"
	plane = EFFECTS_BELOW_LIGHTING_PLANE
	layer = POINTER_LAYER

/obj/effect/landmark/build_marker/dbg_wall
	marker_type = BUILD_MARKER_WALL

/obj/effect/landmark/build_marker/dbg_floor
	marker_type = BUILD_MARKER_FLOOR

/obj/effect/landmark/build_marker/dbg_door
	marker_type = BUILD_MARKER_DOOR

/obj/effect/landmark/build_marker/attack_generic(var/mob/attacker,var/damage,var/attacktext)
	var/mob/living/simple_animal/hostile/builder_mob/builder = attacker
	if(istype(builder) && builder.faction == build_faction)
		var/type_to_build = null
		var/type_remove = null //If set to something, we find it in our tile and delete it.
		var/build_text = "error"
		switch(marker_type)
			if(BUILD_MARKER_WALL)
				build_text = "wall"
				type_to_build = builder.wall_type_build
			if(BUILD_MARKER_FLOOR)
				build_text = "floor"
				type_to_build = builder.floor_type_build
			if(BUILD_MARKER_DOOR)
				build_text = "door"
				type_to_build = builder.door_type_build
				type_remove = /obj/machinery/door
			if(BUILD_MARKER_WINDOW)
				type_to_build = builder.window_type_build
				type_remove = /obj/structure/window
		attacker.visible_message("<span class = 'notice'>[attacker] builds a [build_text].</span>")
		if(type_remove)
			var/atom/to_remove = locate(type_remove) in loc.contents
			while(to_remove)
				qdel(to_remove)
				to_remove = locate(type_remove) in loc.contents

		if(build_text == "wall" || build_text == "floor")
			var/turf/t = loc
			t.ChangeTurf(type_to_build)
		else
			new type_to_build (loc)
		qdel(src)

/mob/living/simple_animal/hostile/builder_mob
	name = "Bob"
	desc = "Can he fix it?"
	see_invisible = 26
	icon_state = "yithian"
	icon_living = "yithian"
	icon_dead = "yithian_dead"
	ranged = 1
	elevation = 1
	var/wall_type_build = /turf/simulated/wall
	var/floor_type_build = /turf/simulated/floor
	var/door_type_build = /obj/machinery/door/unpowered/simple/iron
	var/window_type_build = /obj/structure/window/reinforced/full

/mob/living/simple_animal/hostile/builder_mob/ListTargets(var/dist = 8)
	if(istype(loc,/obj/vehicles))
		var/obj/vehicles/v = loc
		dist *= v.vehicle_view_modifier
	var/list/L = list()

	var/turf/loc_infront = get_step(src,dir)

	for(var/atom/A in view(dist,src.loc) | loc_infront.contents)
		var/obj/effect/landmark/build_marker/mark = A
		if(istype(mark) && mark.build_faction == faction)
			L += A
	return L

/mob/living/simple_animal/hostile/builder_mob/return_valid_target(var/atom/A)
	if(istype(A,/obj/effect/landmark/build_marker))
		stance = HOSTILE_STANCE_ATTACK
		return A

	return null

/mob/living/simple_animal/hostile/builder_mob/SA_attackable(target_mob)
	if(istype(target_mob,/obj/effect/landmark/build_marker))
		return (0)
	return 1

/mob/living/simple_animal/hostile/builder_mob/RangedAttack(var/atom/attacked,var/prox_flag)
	setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	attacked.attack_generic(src,0,"attacks")
	target_mob = null

/mob/living/simple_animal/hostile/builder_mob/dbg_forerunner
	name = "Forerunner Constructor"
	desc = "A drone designed to construct walls, floors and doors wherever needed."
	faction = "Forerunner"
	icon = 'code/modules/halo/Forerunner/Sentinel.dmi'
	icon_state = "sentinel"
	icon_living = "sentinel"
	icon_dead = "sentinel_dead"

	wall_type_build = /turf/simulated/wall/forerunner
	floor_type_build = /turf/simulated/floor/forerunner_alloy
	door_type_build = /obj/machinery/door/unpowered/simple/iron