/datum/build_mode/portals
	name = "Portals"
	icon_state = "buildmode12"
	var/turf/entrance = null
	var/turf/exit = null
	var/list/portals = list()
	var/help_text = {"\
********* Build Mode: Areas ********
Left Click          - Set portal entry/exit points
Left Click + Ctrl   - Delete portal
Right Click         - Remove selected entry/exit points
Right Click + Ctrl  - Delete all portals
************************************\
"}

/datum/build_mode/portals/OnClick(atom/A, list/parameters)
	if (parameters["ctrl"])
		if (parameters["left"])
			if (istype(A, /obj/effect/portal) && (A in portals))
				qdel(A)
				to_chat(user, SPAN_NOTICE("Portal deleted."))
		else if (parameters["right"])
			var/choice = alert("Delete all active portals?", "Delete All", "Yes", "No")

			if (choice == "Yes")
				for (var/obj/effect/portal/P in portals)
					qdel(P)
				portals.Cut()
	else if (parameters["left"])
		if (!entrance)
			entrance = get_turf(A)
			to_chat(user, SPAN_NOTICE("Entrance turf selected: [entrance]"))

		else if (!exit)
			exit = get_turf(A)
			to_chat(user, SPAN_NOTICE("Exit turf selected: [exit]"))
			var/choice = alert("Portal turfs selected. Create the portal now?", "Create Portal?", "Yes", "No")
			if (choice == "No")
				entrance = null
				exit = null
				return

			var/name = input("Give the portal object a name (optional):", "Name") as text | null
			if(!name)
				name = "wormhole"

			var/ttl = input("How long should the portal exist for?" , "Time To Live", 0) as num | null

			if (isnull(ttl) || ttl < 0)
				ttl = rand(30, 60)
			ttl = ttl SECONDS

			var/obj/effect/portal/P = new /obj/effect/portal(entrance, exit, ttl)
			P.SetName(name)
			portals += P

			entrance = null
			exit = null
	else if (parameters["right"])
		entrance = null
		exit = null
		to_chat(user, SPAN_NOTICE("Selection cancelled."))
