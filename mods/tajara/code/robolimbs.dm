/*
Robolimbs for robocats - Restricted roster of prosthetics for tajara
*/

/datum/robolimb/tajara
	company = "NanoTrasen"
	desc = "This limb is made from a cheap polymer. It has stamp reads: produced by NanoTrasen in Mi'dyn Al'Mank."
	icon = 'icons/mob/human_races/cyberlimbs/nanotrasen/nanotrasen_main.dmi'
	restricted_to = list(SPECIES_TAJARA)
	allowed_bodytypes = list(SPECIES_TAJARA)
	applies_to_part = list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	unavailable_at_fab = 1

/datum/robolimb/tajara/dyson
	company = "Dyson-Rhyn'yai Cybernetics"
	desc = "A lightweight prosthesis that claims to imitate the curves of a cat-like body"
	icon = 'mods/tajara/icons/tajara_body/dyson.dmi'

/*
SIERRA TODO: Waiting for sprites instead of plaseholders
/datum/robolimb/tajara/dyson/expensive
	company = "Dyson-Rhyn'yai Premium Series"
	desc = "This high quality limb is nearly indistinguishable from an tajara one."
	icon = 'mods/tajara/icons/tajara_body/dyson-expensive.dmi'
	applies_to_part = BP_ALL_LIMBS
	can_eat = 1
*/
