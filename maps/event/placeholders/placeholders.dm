/datum/build_mode/placeholders
	name = "Placeholder Control"
	icon_state = "mode_ships"
	var/obj/effect/overmap/placeholder/selected

/datum/build_mode/placeholders/Help()
	to_chat(user, {"
__Placeholder Control__
Left-Click - Select / Deselect a placeholder
Right-Click Mode Icon - Set placeholder name / color / light
Right-Click - Rotate a placeholder toward the point
Middle-Click / Ctrl-Click - Jump a placeholder to a point and deselect it
"})

/datum/build_mode/placeholders/Destroy()
	Unselected()
	return ..()

/datum/build_mode/placeholders/Unselected()
	selected = null

/datum/build_mode/placeholders/Configurate()
	if (!selected)
		return
	var/option = alert(user, "Pick name and hit Cancel if you didn't want this.", "Placeholder Options", "Name", "Color", "Sensor")
	if (!option)
		return
	else if (option == "Name")
		option = input(user, "Placeholder Name", null, selected.name) as null | text
		if (isnull(option))
			return
		if (!option)
			selected.name = initial(selected.name)
			selected.desc = initial(selected.desc)
		else
			selected.name = option
			selected.desc = {"[initial(selected.desc)] This one is broadcasting the name "[selected.name]""}
	else if (option == "Color")
		option = input(user, "Placeholder Color", null, selected.color) as null | color
		if (isnull(option))
			return
		selected.color = option
	else if (option == "Sensor")
		option = alert(user, "Sensor Range", null, "Off", "Short", "Far")
		if (isnull(option))
			return
		else if (option == "Off")
			selected.set_light(0)
		else if (option == "Short")
			selected.set_light(1, 2, 3)
		else if (option == "Far")
			selected.set_light(1, 6, 7)

/datum/build_mode/placeholders/OnClick(atom/atom, list/parameters)
	if (!atom)
		return
	var/modifier = parameters["ctrl"]
	if (parameters["left"] && !modifier)
		if (istype(atom, /obj/effect/overmap/placeholder))
			selected = atom
			to_chat(user, "Selected [selected].")
			return
		else
			var/find = locate(/obj/effect/overmap/placeholder) in get_turf(atom)
			if (!find)
				if (!selected)
					to_chat(user, "No placeholders found.")
				to_chat(user, "Deselected [selected].")
				selected = null
				return
			to_chat(user, "Selected [selected].")
		return
	if (!selected)
		to_chat(user, "No placeholder selected.")
		return
	if (parameters["right"])
		var/dx = atom.x - selected.x
		var/dy = atom.y - selected.y
		if (!dx && !dy)
			return
		var/rotation
		if (!dy)
			if (dx > 0)
				rotation = 90
			else
				rotation = 270
		else if (!dx)
			if (dy > 0)
				rotation = 0
			else
				rotation = 180
		else if (dy > 0)
			if (dx > 0)
				rotation = 45
			else
				rotation = 315
		else
			if (dx > 0)
				rotation = 135
			else
				rotation = 225
		animate(
			selected,
			easing = SINE_EASING,
			time = selected.speed * 5 SECONDS,
			transform = matrix().Update(
				scale_x = selected.scale,
				scale_y = selected.scale,
				rotation = rotation
			)
		)
	else if (parameters["middle"] || modifier)
		new /obj/effect/ftl (get_turf(selected))
		new /obj/effect/ftl (get_turf(atom))
		addtimer(CALLBACK(src, .proc/RevealShip, selected, atom.x, atom.y), 2 SECONDS)
		animate(selected, time = 0.5 SECONDS)
		animate(alpha = 0, time = 0.5 SECONDS)
		selected = null

/datum/build_mode/placeholders/proc/RevealShip(atom/movable/ship, at_x, at_y)
	ship.x = at_x
	ship.y = at_y
	animate(ship, alpha = 255, time = 0.5 SECONDS)


/obj/effect/ftl
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = 0
	alpha = 0
	layer = 4


/obj/effect/ftl/Initialize()
	. = ..()
	SetTransform(scale = 0)
	filters += filter(type="blur", size = 2)
	QDEL_IN(src, 3 SECONDS)
	animate(src, transform = matrix().Update(scale_x = 2, scale_y = 2), alpha = 192, time = 0.5 SECONDS)
	animate(time = 2 SECONDS)
	animate(transform = matrix().Update(scale_x = 0, scale_y = 0), alpha = 0, time = 0.5 SECONDS)


/obj/effect/overmap/placeholder
	scannable = TRUE
	known = FALSE
	glide_size = 8
	appearance_flags = EMPTY_BITFIELD
	var/scale = 1
	var/rotation = 0
	var/speed = 1


/obj/effect/overmap/placeholder/Initialize()
	. = ..()
	SetTransform(scale = scale, rotation = rotation)


/obj/effect/overmap/placeholder/gcn_a298
	name = "A298-Class Patrol Vessel"
	desc = "A small, agile military and policing starship built by the Confederation Navy."
	icon = 'gcn-64.dmi'
	icon_state = "pv-a298"
	pixel_x = -16
	pixel_y = -16
	speed = 0.75


/obj/effect/overmap/placeholder/gcn_centurion
	name = "Centurion-Class Frigate"
	desc = "A medium sized military light carrier built by the Confederation Navy."
	icon = 'gcn-64.dmi'
	icon_state = "fr-centurion"
	pixel_x = -16
	pixel_y = -16


/obj/effect/overmap/placeholder/gcn_chevalier
	name = "Chevalier-Class Frigate"
	desc = "A medium sized line warship built by the Confederation Navy."
	icon = 'gcn-64.dmi'
	icon_state = "fr-chevalier"
	pixel_x = -16
	pixel_y = -16
	speed = 0.9


/obj/effect/overmap/placeholder/gcn_lucerne
	name = "Lucerne-Class Destroyer"
	desc = "A large mixed-role capital warship built by the Confederation Navy."
	icon = 'gcn-64.dmi'
	icon_state = "ds-lucerne"
	pixel_x = -16
	pixel_y = -16
	scale = 1.5
	speed = 1.5


/obj/effect/overmap/placeholder/scg_arrow
	name = "Arrow-Class Corvette"
	desc = "A small, aging missile warship built for the Solar Assembly Fleets."
	icon = 'scg-64.dmi'
	icon_state = "cv-arrow"
	pixel_x = -16
	pixel_y = -16
	speed = 1.2


/obj/effect/overmap/placeholder/scg_lexington
	name = "Lexington-Class Corvette"
	desc = "A small, fairly modern missile carrying warship built for the Solar Assembly Fleets."
	icon = 'scg-64.dmi'
	icon_state = "cv-lexington"
	pixel_x = -16
	pixel_y = -16


/obj/effect/overmap/placeholder/scg_rockfish
	name = "Rockfish-Class Corvette"
	desc = "A small, top of the line stealth warship built for the Solar Assembly Fleets."
	icon = 'scg-64.dmi'
	icon_state = "cv-rockfish"
	pixel_x = -16
	pixel_y = -16
	speed = 0.8


/obj/effect/overmap/placeholder/scg_nuum
	name = "Nuum-Class Missile Frigate"
	desc = "An aging medium sized frigate with a heavy focus on missiles, built for the Solar Assembly Fleets."
	icon = 'scg-64.dmi'
	icon_state = "fr-nuum"
	pixel_x = -16
	pixel_y = -16


/obj/effect/overmap/placeholder/scg_somme
	name = "Somme-Class Frigate"
	desc = "A fairly modern medium sized frigate of the line, built for the Solar Assembly Fleets."
	icon = 'scg-64.dmi'
	icon_state = "fr-somme"
	pixel_x = -16
	pixel_y = -16


/obj/effect/overmap/placeholder/scg_kestrel
	name = "Kestrel-Model Starfighter"
	desc = "An aging model of space fighter built for the Solar Assembly Fleets but now common in private ownership."
	icon = 'scg-32.dmi'
	icon_state = "sf-kestrel"
	speed = 0.2


/obj/effect/overmap/placeholder/scg_eagle_ii
	name = "Eagle-II-Model Strike Fighter"
	desc = "A modernized take on a venerable payload-carrying platform, built for the Solar Assembly Fleets."
	icon = 'scg-32.dmi'
	icon_state = "sf-eagle-ii"
	speed = 0.2


/obj/effect/overmap/placeholder/scg_hermes
	name = "Hermes-Model Utility Pod"
	desc = "A tiny workhorse found across human space, able to carry a pilot and some cargo a short distance."
	icon = 'scg-32.dmi'
	icon_state = "uv-hermes"
	speed = 0.4
