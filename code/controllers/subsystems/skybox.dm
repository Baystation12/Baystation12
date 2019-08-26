
//Exists to handle a few global variables that change enough to justify this. Technically a parallax, but it exhibits a skybox effect.
SUBSYSTEM_DEF(skybox)
	name = "Space skybox"
	init_order = SS_INIT_SKYBOX
	flags = SS_NO_FIRE
	var/background_color
	var/skybox_icon = 'icons/turf/skybox.dmi' //Path to our background. Lets us use anything we damn well please. Skyboxes need to be 736x736
	var/background_icon = "dyable"
	var/use_stars = TRUE
	var/use_overmap_details = TRUE
	var/star_path = 'icons/turf/skybox.dmi'
	var/star_state = "stars"
	var/list/skybox_cache = list()

/datum/controller/subsystem/skybox/Initialize()
	. = ..()
	background_color = RANDOM_RGB

/datum/controller/subsystem/skybox/Recover()
	background_color = SSskybox.background_color
	skybox_cache = SSskybox.skybox_cache

/datum/controller/subsystem/skybox/proc/get_skybox(z)
	if(!skybox_cache["[z]"])
		skybox_cache["[z]"] = generate_skybox(z)
	return skybox_cache["[z]"]

/datum/controller/subsystem/skybox/proc/generate_skybox(z)
	if(use_overmap_details)
		var/obj/effect/overmap/O = map_sectors["[z]"]
		if(istype(O))
			var/image/overmap_skybox = O.generate_skybox()
			if(overmap_skybox)
				return overmap_skybox

	var/image/base = get_base_skybox()
	return base

/datum/controller/subsystem/skybox/proc/get_base_skybox()
	var/image/base = image(skybox_icon, icon_state = background_icon)
	base.color = background_color
	if(use_stars)
		var/image/stars = image(skybox_icon, icon_state = star_state)
		stars.appearance_flags = RESET_COLOR
		base.overlays += stars
	return base

/datum/controller/subsystem/skybox/proc/rebuild_skyboxes(var/list/zlevels)
	for(var/z in zlevels)
		skybox_cache["[z]"] = generate_skybox(z)

	for(var/client/C)
		C.update_skybox()

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
			C.update_skybox()
