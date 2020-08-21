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
	if (owner)
		to_chat(owner, SPAN_NOTICE("You start growing \a [cb.get_name()]."))
	visible_message(SPAN_NOTICE("\A [cb.get_name()] starts growing from \the [get_turf(src)]!"))

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
		var/display_name = "unknown organ"
		var/constructed_organ
		if(ispath(construct_path, /obj/structure/chorus))
			constructed_organ = new construct_path(get_turf(src), owner)
			display_name = constructed_organ
			visible_message(SPAN_NOTICE("\The [display_name] finishes growing from \the [get_turf(src)]!"))
		else if(ispath(construct_path, /turf))
			var/turf/T = get_turf(src)
			T.ChangeTurf(construct_path)
			display_name = T
			visible_message(SPAN_NOTICE("\The [display_name] spreads outwards!"))
		else
			constructed_organ = new construct_path(get_turf(src))
			display_name = constructed_organ
			visible_message(SPAN_NOTICE("\The [display_name] finishes growing from \the [get_turf(src)]!"))
	qdel(src)

/obj/structure/chorus_blueprint/proc/stop_building(delete_it = TRUE)
	if(delete_it)
		qdel(src)
