/obj/cosmic_cult/vacuous_breach
	name = "vacuous breach"
	desc = "A complete breach in realspace, allowing passage unto darkness..."
	icon = 'icons/coscult/cosmic-gateway.dmi'
	icon_state = "base"
	pixel_x = -32
	pixel_y = -32

/obj/cosmic_cult/vacuous_breach/Initialize()
	. = ..()
	update_icon()

/obj/cosmic_cult/vacuous_breach/on_update_icon()
	ClearOverlays()
	AddOverlays(list(
		emissive_appearance(icon, "vfx"),
		overlay_image(icon, "vfx")
	))
