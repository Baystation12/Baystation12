/obj/effect/overmap/visitable/sector/exoplanet/get_skybox_representation()
	return skybox_image

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_base_image()
	var/image/base = image('icons/skybox/planet.dmi', "base")
	base.color = get_surface_color()
	return base

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_planet_image()
	skybox_image = image('icons/skybox/planet.dmi', "")

	skybox_image.overlays += get_base_image()

	for (var/datum/exoplanet_theme/theme in themes)
		skybox_image.overlays += theme.get_planet_image_extra()

	if (water_color) //TODO: move water levels out of randommap into exoplanet
		var/image/water = image('icons/skybox/planet.dmi', "water")
		water.color = water_color
		water.appearance_flags = DEFAULT_APPEARANCE_FLAGS | PIXEL_SCALE
		water.transform = water.transform.Turn(rand(0,360))
		skybox_image.overlays += water

	if (atmosphere && atmosphere.return_pressure() > SOUND_MINIMUM_PRESSURE)

		var/atmo_color = get_atmosphere_color()
		if (!atmo_color)
			atmo_color = COLOR_WHITE

		var/image/clouds = image('icons/skybox/planet.dmi', "weak_clouds")

		if (water_color)
			clouds.overlays += image('icons/skybox/planet.dmi', "clouds")

		clouds.color = atmo_color
		skybox_image.overlays += clouds

		var/image/atmo = image('icons/skybox/planet.dmi', "atmoring")
		skybox_image.underlays += atmo

	var/image/shadow = image('icons/skybox/planet.dmi', "shadow")
	shadow.blend_mode = BLEND_MULTIPLY
	skybox_image.overlays += shadow

	var/image/light = image('icons/skybox/planet.dmi', "lightrim")
	skybox_image.overlays += light

	if (prob(20))
		var/image/rings = image('icons/skybox/planet_rings.dmi')
		rings.icon_state = pick("sparse", "dense")
		rings.color = pick("#f0fcff", "#dcc4ad", "#d1dcad", "#adb8dc")
		rings.pixel_x = -128
		rings.pixel_y = -128
		skybox_image.overlays += rings

	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY
