/datum/build_mode/missile
	name = "Missiles"
	icon_state = "mode_missiles"
	var/atom/target = null
	var/missile_type = /obj/structure/missile/he
	var/help_text = {"\
********* Build Mode: Areas ********
Left Click          - Spawn and fire missile
Right Click         - Set missile target
Right Click Icon    - Change missile type

Missiles can be spawned on the overmap or in the world, but its target MUST be an overmap sector or turf.
************************************\
"}

/datum/build_mode/missile/Help()
	to_chat(user, SPAN_NOTICE(help_text))

/datum/build_mode/missile/Configurate()
	var/list/types = subtypesof(/obj/structure/missile)
	var/input_type = input("Select a type", "Select Type", types[1]) as null|anything in types
	if (ispath(input_type, /obj/structure/missile))
		missile_type = input_type
		to_chat("Missile type set to [missile_type]")

/datum/build_mode/missile/OnClick(atom/clicked_atom, list/parameters)
	if (parameters[MOUSE_2])
		if ((isturf(clicked_atom) && (istype(clicked_atom, /turf/unsimulated/map)) || istype(clicked_atom, /obj/overmap/visitable) || istype(clicked_atom, /obj/overmap/projectile)))
			target = clicked_atom
			to_chat(user, SPAN_NOTICE("Target set to [clicked_atom]"))
			return
		to_chat(user, SPAN_WARNING("Invalid target - must be a visitable overmap sector, or an overmap turf."))
	else if (parameters[MOUSE_1])
		if (!missile_type)
			to_chat(user, SPAN_NOTICE("You must specify a missile type first!"))
			return
		var/turf/spawn_turf = get_turf(clicked_atom)
		spawn_missile(spawn_turf, target)

/datum/build_mode/missile/proc/spawn_missile(turf/spawn_turf, atom/target)
	set waitfor = FALSE

	var/obj/structure/missile/new_missile = new missile_type()
	new_missile.set_dir(host.dir)
	new_missile.set_target(target)
	Log("Created a [new_missile] [istype(spawn_turf, /turf/unsimulated/map) ? "at [spawn_turf]" : "at [spawn_turf.x], [spawn_turf.y], [spawn_turf.z]"] with the target [target]")

	if (istype(spawn_turf, /turf/unsimulated/map))
		var/obj/overmap/projectile/overmap_missile = new(spawn_turf)
		overmap_missile.set_missile(new_missile)
		new_missile.overmap_missile = overmap_missile
		new_missile.arm()
		new_missile.touch_map_edge()
	else
		new_missile.forceMove(spawn_turf)
		new_missile.arm()
		new_missile.fire()
