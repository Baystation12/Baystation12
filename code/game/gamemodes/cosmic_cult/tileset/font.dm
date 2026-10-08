/obj/cosmic_cult/malign_font
	name = "malign font"
	desc = "An eerie structure that reacts to the presence of those nearby..."
	icon = 'icons/coscult/cosmic-font.dmi'
	icon_state = "icon"

/obj/cosmic_cult/malign_font/Initialize()
	. = ..()
	update_icon()

/obj/cosmic_cult/malign_font/on_update_icon()
	ClearOverlays()
	AddOverlays(list(
		emissive_appearance(icon, "unshaded"),
		overlay_image(icon, "unshaded")
	))

/obj/cosmic_cult/malign_font/flipped
	transform = matrix(-1, 0, 0, 0, 1, 0)
