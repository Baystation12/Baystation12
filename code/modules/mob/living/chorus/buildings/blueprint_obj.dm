/obj/structure/chorus_blueprint
	icon = 'icons/obj/cult.dmi'
	var/construct_max = 0
	var/construct_left = 0
	var/construct_path
	var/mob/living/chorus/owner
	alpha = 25
	density = FALSE

/obj/structure/chorus_blueprint/Initialize(var/maploading, var/datum/chorus_building/cb, var/constructor)
	. = ..()
	construct_path = cb.building_type_to_build
	name = "[cb.get_name()] (blueprint)"
	icon_state = cb.get_icon_state()
	owner = constructor
	overlays += image('icons/obj/items.dmi', src, "blueprints")
	construct_max = cb.build_time
	construct_left = cb.build_time

/obj/structure/chorus_blueprint/Destroy()
	if(owner)
		owner.stop_building(src, FALSE)
		owner = null
	. = ..()

/obj/structure/chorus_blueprint/proc/build_amount(var/amt)
	construct_left -= amt
	if(construct_left <= 0)
		construct_target()
		return TRUE
	else
		alpha = 255 - 230 * round(construct_left)/construct_max
		return FALSE

/obj/structure/chorus_blueprint/proc/construct_target()
	if(construct_path)
		if(ispath(construct_path, /obj/structure/chorus))
			new construct_path(get_turf(src), owner)
		else if(ispath(construct_path, /turf))
			var/turf/T = get_turf(src)
			T.ChangeTurf(construct_path)
		else
			new construct_path(get_turf(src))
	qdel(src)