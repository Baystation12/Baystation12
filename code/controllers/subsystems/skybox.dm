
//Exists to handle a few global variables that change enough to justify this. Technically a parallax, but it exhibits a skybox effect.
SUBSYSTEM_DEF(skybox)
	name = "Space skybox"
	init_order = SS_INIT_SKYBOX
	flags = SS_NO_FIRE
	var/background_color
	var/skybox_icon = 'icons/skybox/skybox.dmi' //Path to our background. Lets us use anything we damn well please. Skyboxes need to be 736x736
	var/background_icon = "dyable"
	var/use_stars = TRUE
	var/use_overmap_details = TRUE
	var/star_path = 'icons/skybox/skybox.dmi'
	var/star_state = "stars"
	var/list/skybox_cache = list()
	var/list/space_appearance_cache

/datum/controller/subsystem/skybox/PreInit()
	build_space_appearances()


/datum/controller/subsystem/skybox/UpdateStat(time)
	return


/datum/controller/subsystem/skybox/proc/build_space_appearances()
	space_appearance_cache = new(26)
	for (var/i in 0 to 25)
		var/mutable_appearance/dust = mutable_appearance('icons/turf/space_dust.dmi', "[i]")
		dust.plane = DUST_PLANE
		dust.alpha = 80
		dust.blend_mode = BLEND_ADD

		var/mutable_appearance/space = new /mutable_appearance(/turf/space)
		space.icon_state = "white"
		space.overlays += dust
		space_appearance_cache[i + 1] = space.appearance

/datum/controller/subsystem/skybox/Initialize(start_uptime)
	background_color = RANDOM_RGB

/datum/controller/subsystem/skybox/Recover()
	background_color = SSskybox.background_color
	skybox_cache = SSskybox.skybox_cache

/datum/controller/subsystem/skybox/proc/get_skybox(z)
	if(!skybox_cache["[z]"])
		skybox_cache["[z]"] = generate_skybox(z)
		if(GLOB.using_map.use_overmap)
			var/obj/effect/overmap/visitable/O = map_sectors["[z]"]
			if(istype(O))
				for(var/zlevel in O.map_z)
					skybox_cache["[zlevel]"] = skybox_cache["[z]"]
	return skybox_cache["[z]"]

/datum/controller/subsystem/skybox/proc/generate_skybox(z)
	var/image/res = image(skybox_icon)

	var/image/base = overlay_image(skybox_icon, background_icon, background_color)

	if(use_stars)
		var/image/stars = overlay_image(skybox_icon, star_state, flags = RESET_COLOR)
		base.overlays += stars

	res.overlays += base

	if(GLOB.using_map.use_overmap && use_overmap_details)
		var/obj/effect/overmap/visitable/O = map_sectors["[z]"]
		if(istype(O))
			var/image/overmap = image(skybox_icon)
			overmap.overlays += O.generate_skybox()
			for(var/obj/effect/overmap/visitable/other in O.loc)
				if(other != O)
					overmap.overlays += other.get_skybox_representation()
			overmap.appearance_flags |= RESET_COLOR
			res.overlays += overmap

	for(var/datum/event/E in SSevent.active_events)
		if(E.has_skybox_image && E.isRunning && (z in E.affecting_z))
			res.overlays += E.get_skybox_image()

	return res

/datum/controller/subsystem/skybox/proc/rebuild_skyboxes(var/list/zlevels)
	for(var/z in zlevels)
		skybox_cache["[z]"] = generate_skybox(z)

	for(var/client/C)
		C.update_skybox(1)

//Update skyboxes. Called by universes, for now.
/datum/controller/subsystem/skybox/proc/change_skybox(new_state, new_color, new_use_stars, new_use_overmap_details)
	var/need_rebuild = FALSE
	if(new_state != background_icon)
		background_icon = new_state
		need_rebuild = TRUE

	if(new_color != background_color)
		background_color = new_color
		need_rebuild = TRUE

	if(new_use_stars != use_stars)
		use_stars = new_use_stars
		need_rebuild = TRUE

	if(new_use_overmap_details != use_overmap_details)
		use_overmap_details = new_use_overmap_details
		need_rebuild = TRUE

	if(need_rebuild)
		skybox_cache.Cut()

		for(var/client/C)
			C.update_skybox(1)
