// makes custom colored overlay, can also generate scanline
/datum/global_hud/proc/setup_custom_overlay(var/color, var/scanline = FALSE)
	var/obj/screen/screen = new /obj/screen()
	screen.screen_loc = "WEST,SOUTH to EAST,NORTH"
	screen.icon = 'proxima/icons/obj/hud_full.dmi'
	screen.plane = FULLSCREEN_PLANE
	screen.layer = FULLSCREEN_LAYER
	screen.mouse_opacity = 0
	screen.alpha = 125

	screen.blend_mode = BLEND_MULTIPLY
	if(color)
		screen.color = color
		screen.icon_state = "color"

	if(scanline)
		screen.icon_state = "scanline"

	return screen

/datum/global_hud/New()
	nvg = setup_custom_overlay("#06ff00", TRUE)
	thermal = setup_custom_overlay("#ff0000", TRUE)
	meson = setup_custom_overlay("#9fd800", TRUE)
	science = setup_custom_overlay("#d600d6", TRUE)
