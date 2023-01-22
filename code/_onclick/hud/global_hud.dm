/*
	The global hud:
	Uses the same visual objects for all players.
*/

GLOBAL_DATUM_INIT(global_hud, /datum/global_hud, new())

/datum/global_hud
	var/obj/screen/nvg
	var/obj/screen/thermal
	var/obj/screen/meson
	var/obj/screen/science
	var/obj/screen/holomap

/datum/global_hud/proc/setup_overlay(var/icon_state)
	var/obj/screen/screen = new /obj/screen()
	screen.screen_loc = "1,1"
	screen.icon = 'icons/obj/hud_full.dmi'
	screen.icon_state = icon_state
	screen.mouse_opacity = 0

	return screen

/datum/global_hud/New()
	nvg = setup_overlay("nvg_hud")
	thermal = setup_overlay("thermal_hud")
	meson = setup_overlay("meson_hud")
	science = setup_overlay("science_hud")

	//Holomap screen object is invisible and work
	//By setting it as n images location, without icon changes
	//Make it part of global hud since it's inmutable
	holomap = new /obj/screen()
	holomap.name = "holomap"
	holomap.icon = null
	holomap.layer = HUD_BASE_LAYER
	holomap.screen_loc = UI_HOLOMAP
	holomap.mouse_opacity = 0
