/datum/build_mode/visible_portals
	name = "Visible Portals"
	icon_state = "mode_vis_portal"
	var/list/entrance
	var/list/exit
	var/help_text = {"\
********* Build Mode: Visible Portal ********
Left Click          - Add portal entrance segment
Left Click + Ctrl   - Add portal exit segment
Right Click         - Delete current work

Right click the icon when you're done creating both portals to finish

Match the portal lines exactly (including order of placement, ie, top to bottom for both) else you will run into valid but very confusing to look at setups!
Tool doesnt provide validation!
************************************\
"}

/obj/effect/map_effect/temp/portal_marker
	invisibility = INVISIBILITY_OBSERVER
	icon = 'icons/effects/map_effects.dmi'

/datum/build_mode/visible_portals/proc/AddMarker(turf/T, dir, entry)
	var/obj/effect/map_effect/temp/portal_marker/PM = new(T)
	PM.dir = dir
	if (entry)
		PM.icon_state = "portal_line_side_a"
		if (LAZYLEN(entrance))
			var/obj/effect/map_effect/temp/portal_marker/M = LAZYACCESS(entrance, 1)
			PM.dir = M.dir
		LAZYADD(entrance, PM)
	else
		PM.icon_state = "portal_line_side_b"
		if (LAZYLEN(exit))
			var/obj/effect/map_effect/temp/portal_marker/M = LAZYACCESS(exit, 1)
			PM.dir = M.dir
		LAZYADD(exit, PM)

/datum/build_mode/visible_portals/proc/FinishPortals()
	for (var/i = LAZYLEN(entrance) to 1 step -1)
		var/obj/effect/map_effect/temp/portal_marker/A = LAZYACCESS(entrance, i)
		var/obj/effect/map_effect/temp/portal_marker/B = LAZYACCESS(exit, i)
		var/turf/T1 = get_turf(A)
		var/turf/T2 = get_turf(B)
		if (i == 1)
			var/id = "\ref[A]"
			var/obj/effect/map_effect/portal/master/MA  = new (T1, id, A.dir)
			var/obj/effect/map_effect/portal/master/MB  = new (T2, id, B.dir)
			MA.assemble()
			MB.assemble()
		else
			var/obj/effect/map_effect/portal/line/LA = new (T1)
			LA.dir = A.dir
			var/obj/effect/map_effect/portal/line/LB = new (T2)
			LB.dir = B.dir
	QDEL_NULL_LIST(entrance)
	QDEL_NULL_LIST(exit)

/datum/build_mode/visible_portals/Configurate()
	. = ..()
	if (LAZYLEN(entrance) == LAZYLEN(exit))
		if (LAZYLEN(entrance))
			FinishPortals()
		else
			to_chat(user, SPAN_WARNING("You haven't constructed a portal!"))
	else
		to_chat(user, SPAN_WARNING("Entry and exit portals are not same length!"))

/datum/build_mode/visible_portals/OnClick(atom/A, list/parameters)
	var/turf/location = get_turf(A)
	if (parameters["ctrl"])
		if (parameters["left"])
			AddMarker(location, GLOB.reverse_dir[user.dir], FALSE)
	else if (parameters["left"] )
		AddMarker(location, GLOB.reverse_dir[user.dir], TRUE)
	else if (parameters["right"])
		var/choice = alert("Delete in progress portal", "Delete All", "Yes", "No")
		if (choice == "Yes")
			QDEL_NULL_LIST(entrance)
			QDEL_NULL_LIST(exit)

/datum/build_mode/visible_portals/Unselected()
	QDEL_NULL_LIST(entrance)
	QDEL_NULL_LIST(exit)
