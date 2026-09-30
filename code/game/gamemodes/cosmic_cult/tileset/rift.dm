/obj/cosmic_cult/rift
	name = "malign rift"
	desc = "A malign light pours forth from within."
	icon = 'icons/coscult/cosmic-rift.dmi'
	icon_state = "base"
	anchored = TRUE

/obj/cosmic_cult/rift/Initialize()
	. = ..()
	update_icon()
	START_PROCESSING(SScosmic_corruption, src)
	set_light(2, 2, "#42a4ae")

/obj/cosmic_cult/rift/on_update_icon()
	ClearOverlays()
	AddOverlays(list(
		overlay_image(icon, "vfx"),
		emissive_appearance(icon, "vfx")
	))

/obj/cosmic_cult/rift/Process()
	. = ..()
