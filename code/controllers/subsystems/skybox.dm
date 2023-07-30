SUBSYSTEM_DEF(skybox)
	name = "Space skybox"
	init_order = SS_INIT_SKYBOX
	flags = SS_NO_FIRE

	/// The background color of space in the current round
	var/static/background_color

	/// The skybox icon file to use for backgrounds. Expects to be 736x736
	var/static/skybox_icon = 'icons/skybox/skybox.dmi'

	/// The skybox icon state to use
	var/static/background_icon = "dyable"

	/// whether the current skybox uses stars
	var/static/use_stars = TRUE

	/// whether the current skybox collected an extra appearance from an overmap feature
	var/static/use_overmap_details = TRUE

	/// The skybox icon file to use for stars. Expects to be 736x736
	var/static/star_path = 'icons/skybox/skybox.dmi'

	/// The skybox icon state to use for stars
	var/static/star_state = "stars"

	/// A "z" => /image map of skyboxes already generated
	var/static/list/skybox_cache = list()

	/// The skybox icon file to use for dust
	var/static/dust_path = 'icons/turf/space_dust.dmi'

	/// An "index" => /image map of cached space backgrounds
	var/static/list/space_appearance_cache = new (26)


/datum/controller/subsystem/skybox/Initialize(start_uptime)
	for (var/index = 1 to length(space_appearance_cache))
		var/mutable_appearance/dust = mutable_appearance(dust_path, "[index]")
		dust.plane = DUST_PLANE
		dust.alpha = 80
		dust.blend_mode = BLEND_ADD
		var/mutable_appearance/space = new /mutable_appearance(/turf/space)
		space.icon_state = "white"
		space.overlays += dust
		space_appearance_cache[index] = space.appearance
	background_color = RANDOM_RGB


/datum/controller/subsystem/skybox/proc/get_skybox(z)
	if (!skybox_cache["[z]"])
		skybox_cache["[z]"] = generate_skybox(z)
		if (GLOB.using_map.use_overmap)
			var/obj/effect/overmap/visitable/O = map_sectors["[z]"]
			if (istype(O))
				for (var/zlevel in O.map_z)
					skybox_cache["[zlevel]"] = skybox_cache["[z]"]
	return skybox_cache["[z]"]


/datum/controller/subsystem/skybox/proc/generate_skybox(z)
	var/image/res = image(skybox_icon)
	var/image/base = overlay_image(skybox_icon, background_icon, background_color)
	if (use_stars)
		var/image/stars = overlay_image(skybox_icon, star_state, flags = RESET_COLOR)
		base.overlays += stars
	res.overlays += base
	if (GLOB.using_map.use_overmap && use_overmap_details)
		var/obj/effect/overmap/visitable/O = map_sectors["[z]"]
		if (istype(O))
			var/image/overmap = image(skybox_icon)
			overmap.overlays += O.generate_skybox()
			for (var/obj/effect/overmap/visitable/other in O.loc)
				if (other != O)
					overmap.overlays += other.get_skybox_representation()
			overmap.appearance_flags |= RESET_COLOR
			res.overlays += overmap
	for (var/datum/event/event as anything in SSevent.active_events)
		if (event.has_skybox_image && event.isRunning && (z in event.affecting_z))
			res.overlays += event.get_skybox_image()
	return res


/datum/controller/subsystem/skybox/proc/rebuild_skyboxes(list/zlevels)
	for (var/z in zlevels)
		skybox_cache["[z]"] = generate_skybox(z)
	for (var/client/client as anything in GLOB.clients)
		client.update_skybox(TRUE)


/datum/controller/subsystem/skybox/proc/change_skybox(new_state, new_color, new_use_stars, new_use_overmap_details)
	var/need_rebuild = FALSE
	if (new_state != background_icon)
		background_icon = new_state
		need_rebuild = TRUE
	if (new_color != background_color)
		background_color = new_color
		need_rebuild = TRUE
	if (new_use_stars != use_stars)
		use_stars = new_use_stars
		need_rebuild = TRUE
	if (new_use_overmap_details != use_overmap_details)
		use_overmap_details = new_use_overmap_details
		need_rebuild = TRUE
	if (need_rebuild)
		skybox_cache.Cut()
		for (var/client/client as anything in GLOB.clients)
			client.update_skybox(TRUE)
