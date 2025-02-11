#include "northstar_comms.dm"
#include "northstar_decor.dm"

/datum/map_template/ruin/northstar
	name = "Maxim Interplanar Layover"
	id = "northstar"
	description = "Considered a standout in recent Solar-Gilgameshi relations. Joint Station Northstar, as dubbed by the Solar Assembly - and Krasnyy-Balise by the Gilgameshi rests atop Maxim's World. It is transmitting a unique free-for-all IDENT-tag 'MIL-E14b'."
	suffixes = list("maps/event/e14b_station/northstar-1.dmm", "maps/event/e14b_station/northstar-2.dmm", "maps/event/e14b_station/northstar-3.dmm")
	spawn_cost = 1


/obj/overmap/visitable/sector/northstar
	name = "Maxim Interplanar Layover"
	desc = "Considered a standout in recent Solar-Gilgameshi relations. Joint Station Northstar, as dubbed by the Solar Assembly - and Krasnyy-Balise by the Gilgameshi rests atop Maxim's World. It is transmitting a unique free-for-all IDENT-tag 'MIL-E14b'."
	icon = 'icons/overmap.dmi'
	icon_state = "northstar"
	hide_from_reports = FALSE
	scannable = TRUE
	sensor_visibility = 15


/obj/overmap/visitable/sector/northstar/generate_skybox()
	var/image/res = image('icons/skybox/planet.dmi', "")

	res.AddOverlays(image('icons/skybox/planet.dmi', "base", COMMS_COLOR_BEARCAT, RESET_COLOR))
	res.AddOverlays(image('icons/skybox/planet.dmi', "water", COMMS_COLOR_VERNE, RESET_COLOR))

	var/image/clouds = image('icons/skybox/planet.dmi', "weak_clouds")
	clouds.AddOverlays(image('icons/skybox/planet.dmi', "clouds"))

	clouds.color = COMMS_COLOR_BEARCAT

	res.AddOverlays(clouds)

	var/image/atmo = image('icons/skybox/planet.dmi', "atmoring")
	res.underlays += atmo

	var/image/shadow = image('icons/skybox/planet.dmi', "shadow")
	shadow.blend_mode = BLEND_MULTIPLY
	res.AddOverlays(shadow)

	var/image/light = image('icons/skybox/planet.dmi', "lightrim")
	res.AddOverlays(light)

	res.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	res.blend_mode = BLEND_OVERLAY
	res.SetTransform(scale = 2)

	res.pixel_x = 70
	res.pixel_y = 96

	return res


/obj/overmap/visitable/sector/northstar/get_skybox_representation()
	var/image/res = image('icons/skybox/planet.dmi', "")

	res.AddOverlays(image('icons/skybox/planet.dmi', "base", COMMS_COLOR_BEARCAT, RESET_COLOR))
	res.AddOverlays(image('icons/skybox/planet.dmi', "water", COMMS_COLOR_VERNE, RESET_COLOR))

	var/image/clouds = image('icons/skybox/planet.dmi', "weak_clouds")
	clouds.AddOverlays(image('icons/skybox/planet.dmi', "clouds"))

	clouds.color = COMMS_COLOR_BEARCAT

	res.AddOverlays(clouds)

	var/image/atmo = image('icons/skybox/planet.dmi', "atmoring")
	res.underlays += atmo

	var/image/shadow = image('icons/skybox/planet.dmi', "shadow")
	shadow.blend_mode = BLEND_MULTIPLY
	res.AddOverlays(shadow)

	var/image/light = image('icons/skybox/planet.dmi', "lightrim")
	res.AddOverlays(light)

	res.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	res.blend_mode = BLEND_OVERLAY
	res.SetTransform(scale = 2)

	res.pixel_x = 70
	res.pixel_y = 96

	return res


/*
* AREAS
*/

/area/northstar
	icon = 'maps/event/e14b_station/icons/northstar.dmi'
	req_access = list("ACCESS_TORCH_CREW")


// Deck One
/area/northstar/deckone
	name = "Maxim Interplanar Deck One"
	icon_state = "d1"


// Deck Two
/area/northstar/decktwo
	name = "Maxim Interplanar Deck Two"
	icon_state = "d2"


// Deck Three
/area/northstar/deckthree
	name = "Maxim Interplanar Deck Three"
	icon_state = "d3"
