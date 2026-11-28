/mob/living/cosmic_cult/wisp
	icon = 'icons/effects/effects.dmi'
	icon_state = "nothing"
	var/to_convert = FALSE

/mob/living/cosmic_cult/wisp/Initialize()
	. = ..()
	update_icon()
	set_light(4, 2, "#42a4ae")

	add_language(LANGUAGE_MALIGN_LOCAL)
	set_default_language(all_languages[LANGUAGE_MALIGN_LOCAL])

/mob/living/cosmic_cult/wisp/on_update_icon()
	ClearOverlays()

	underlays = list()
	underlays += image('icons/coscult/cosmic-wisp.dmi', "shadow-medium", pixel_z = -8)

	var/image/overlay = overlay_image('icons/coscult/cosmic-wisp.dmi', "wisp")
	overlay.pixel_z = 8
	var/image/emissive = emissive_appearance('icons/coscult/cosmic-wisp.dmi', "wisp")
	emissive.pixel_z = 8

	AddOverlays(list(overlay, emissive))

/mob/living/cosmic_cult/wisp/attack_hand(mob/user)
	. = ..()

	if (!is_cosmic_cultist(user) || to_convert)
		return

	if (!GLOB.cosmic_cult.can_become_antag(src.mind, 1))
		to_chat(src, SPAN_MALIGN("As \the [user] touches you, a strange coldness fills your form. You see curtains in the distant void, lunatics trying to pull them down."))
		to_chat(src, SPAN_MALIGN("You realize what could happen if the curtains fall."))
	else
		to_chat(src, SPAN_MALIGN("As \the [user] touches you, a strange coldness fills your form. The world suffers so much. Wouldn't it be nice if you could bring an end to it all?"))
		to_chat(src, SPAN_MALIGN("Do you wish to join the cult and help the curtains fall?<br><a href='byond://?src=\ref[src];join=1'>Join the cult</a>."))

/mob/living/cosmic_cult/wisp/Topic(href, href_list)
	if(usr != src)
		return

	if(href_list["join"])
		to_convert = TRUE
		to_chat(src, SPAN_MALIGN("A gentle revelation fills your disembodied mind. You feel as if your body in realspace awaits you."))
