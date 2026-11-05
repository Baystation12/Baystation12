/obj/cosmic_cult/lamp
	name = "malign light"
	desc = "A mote of un-light shimmers within."
	icon = 'icons/coscult/cosmic-light.dmi'
	icon_state = "base"

/obj/cosmic_cult/lamp/Initialize()
	. = ..()
	update_icon()

/obj/cosmic_cult/lamp/on_update_icon()
	ClearOverlays()
	AddOverlays(list(
		emissive_appearance(icon, "glow"),
		overlay_image(icon, "glow")
	))
	set_light(6, 1, "#42a4ae")
