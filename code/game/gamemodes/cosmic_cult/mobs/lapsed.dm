/mob/living/cosmic_cult/lapse
	name = "???"
	desc = "Trapped in a lapse between here and there."
	icon = 'icons/coscult/ability-lapse-polymorph.dmi'
	icon_state = "human"
	anchored = TRUE

/mob/living/cosmic_cult/lapse/Initialize()
	. = ..()
	update_icon()
	set_light(2, 2, "#42a4ae")

/mob/living/cosmic_cult/lapse/on_update_icon()
	ClearOverlays()
	AddOverlays(list(
		overlay_image(icon, icon_state),
		emissive_appearance(icon, icon_state)
	))

/mob/living/cosmic_cult/lapse/large
	icon = 'icons/coscult/ability-lapse-polymorph-large.dmi'
	pixel_x = -16
	light_offset_x = 0

/mob/living/cosmic_cult/lapse/human
/mob/living/cosmic_cult/lapse/unathi/icon_state = "unathi"
/mob/living/cosmic_cult/lapse/vox/icon_state = "vox"
/mob/living/cosmic_cult/lapse/diona/icon_state = "diona"
/mob/living/cosmic_cult/lapse/machine/icon_state = "machine"
/mob/living/cosmic_cult/lapse/large/adherent/icon_state = "adherent"
/mob/living/cosmic_cult/lapse/large/skrell/icon_state = "skrell"
/mob/living/cosmic_cult/lapse/large/nabber/icon_state = "nabber"
