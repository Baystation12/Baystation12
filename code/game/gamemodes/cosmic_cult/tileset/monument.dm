/obj/cosmic_cult/monument
	name = "\improper The Monument"
	desc = "Built of a thousand little nothings, its surface reflects a starless emptiness..."
	icon = 'icons/coscult/cosmic-monument.dmi'
	icon_state = "base"
	pixel_x = -32
	bound_x = -32
	bound_width = 96
	density = TRUE
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER

/obj/cosmic_cult/monument/Initialize()
	. = ..()
	update_icon()

/obj/cosmic_cult/monument/on_update_icon()
	set_light(6, 1, "#42a4ae")

/obj/cosmic_cult/monument/attack_hand(mob/living/user)
	cosmic_cult_shockwave_vfx(src)
