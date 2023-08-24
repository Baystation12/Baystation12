/client
	var/obj/screen/screentip/screentip

/client/New()
	. = ..()
	screentip = new
	if (SScharacter_setup.initialized)
		screentip.set_show(get_preference_value(/datum/client_preference/show_screentip) == GLOB.PREF_SHOW)

/mob/new_player/deferred_login()
	. = ..()
	client?.screentip.set_show(get_preference_value(/datum/client_preference/show_screentip) == GLOB.PREF_SHOW)

/obj/screen/screentip
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	screen_loc = "TOP, CENTER - 3"
	maptext_width = 256
	maptext_height = 480
	maptext_x = -16
	plane = HUD_PLANE
	layer = UNDER_HUD_LAYER
	var/show = TRUE

/obj/screen/screentip/proc/set_text(text)
	if (show)
		maptext = "<span class='maptext' style='text-align: center; font-size: 32px; color: #f0f0f0'>[text]</span>"

/obj/screen/screentip/proc/set_show(show)
	src.show = show
	if (!show)
		maptext = ""
