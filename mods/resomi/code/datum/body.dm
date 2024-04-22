// PROSTHETIC ORGANS

/datum/robolimb/resomi
	company = "Small prosthetic"
	desc = "This prosthetic is small and fit for nonhuman proportions."
	icon = 'mods/resomi/icons/resomi_main.dmi'
	species_cannot_use = list(SPECIES_ADHERENT, SPECIES_YEOSA, SPECIES_UNATHI, SPECIES_NABBER, SPECIES_DIONA)
	restricted_to = list(SPECIES_RESOMI)
	allowed_bodytypes = list(SPECIES_RESOMI)
	applies_to_part = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_L_HAND, BP_R_HAND)

// HAIR

/datum/sprite_accessory/hair/resomi
	name = "Resomi Plumage"
	icon_state = "resomi_default"
	icon = 'packs/infinity/icons/mob/human_races/species/resomi/hair.dmi'
	species_allowed = list(SPECIES_RESOMI)

/datum/sprite_accessory/hair/resomi/ears
	name = "Resomi Ears"
	icon_state = "resomi_ears"

/datum/sprite_accessory/hair/resomi/excited
	name = "Resomi Spiky"
	icon_state = "resomi_spiky"

/datum/sprite_accessory/hair/resomi/hedgehog
	name = "Resomi Hedgehog"
	icon_state = "resomi_hedge"

/datum/sprite_accessory/hair/resomi/long
	name = "Resomi Unpruned"
	icon_state = "resomi_long"

/datum/sprite_accessory/hair/resomi/sunburst
	name = "Resomi Sunburst"
	icon_state = "resomi_burst_short"

/datum/sprite_accessory/hair/resomi/mohawk
	name = "Resomi Mohawk"
	icon_state = "resomi_mohawk"

/datum/sprite_accessory/hair/resomi/pointy
	name = "Resomi Pointy"
	icon_state = "resomi_pointy"

/datum/sprite_accessory/hair/resomi/upright
	name = "Resomi Upright"
	icon_state = "resomi_upright"

/datum/sprite_accessory/hair/resomi/mane
	name = "Resomi Mane"
	icon_state = "resomi_mane"

/datum/sprite_accessory/hair/resomi/mane_beardless
	name = "Resomi Large Ears"
	icon_state = "resomi_mane_beardless"

/datum/sprite_accessory/hair/resomi/droopy
	name = "Resomi Droopy"
	icon_state = "resomi_droopy"

/datum/sprite_accessory/hair/resomi/mushroom
	name = "Resomi Mushroom"
	icon_state = "resomi_mushroom"

/datum/sprite_accessory/hair/resomi/twies
	name = "Resomi Twies"
	icon_state = "resomi_twies"

/datum/sprite_accessory/hair/resomi/backstrafe
	name = "Resomi Backstrafe"
	icon_state = "resomi_backstrafe"

/datum/sprite_accessory/hair/resomi/longway
	name = "Resomi Long way"
	icon_state = "resomi_longway"

/datum/sprite_accessory/hair/resomi/notree
	name = "Resomi Tree"
	icon_state = "resomi_notree"

/datum/sprite_accessory/hair/resomi/fluffymohawk
	name = "Resomi Fluffy Mohawk"
	icon_state = "resomi_fluffymohawk"

// MARKINGS

/datum/sprite_accessory/marking/resomi
	icon = 'packs/infinity/icons/mob/human_races/species/resomi/markings.dmi'
	species_allowed = list(SPECIES_RESOMI)
	do_coloration = TRUE

/datum/sprite_accessory/marking/resomi/resomi_fluff
	name = "Resomi underfluff"
	icon_state = "resomi_fluff"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_GROIN,BP_CHEST,BP_HEAD)

/datum/sprite_accessory/marking/resomi/resomi_small_feathers
	name = "Resomi small wingfeathers"
	icon_state = "resomi_sf"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND,BP_CHEST)
