var/list/all_robolimbs = list()
var/list/chargen_robolimbs = list()
var/datum/robolimb/basic_robolimb

/proc/populate_robolimb_list()
	basic_robolimb = new()
	for(var/limb_type in typesof(/datum/robolimb))
		var/datum/robolimb/R = new limb_type()
		all_robolimbs[R.company] = R
		if(!R.unavailable_at_chargen)
			chargen_robolimbs[R.company] = R


/datum/robolimb
	var/company = "Unbranded"                                 // Shown when selecting the limb.
	var/desc = "A generic unbranded robotic prosthesis."      // Seen when examining a limb.
	var/icon = 'icons/mob/human_races/cyberlimbs/robotic.dmi' // Icon base to draw from.
	var/unavailable_at_chargen                                // If set, not available at chargen.
	var/unavailable_at_fab                                    // If set, cannot be fabricated.
	var/can_eat
	var/has_eyes = TRUE
	var/can_feel_pain
	var/skintone
	var/list/species_cannot_use = list()
	var/list/restricted_to = list()
	var/list/applies_to_part = list() //TODO.
	var/list/allowed_bodytypes = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_SKRELL, SPECIES_UNATHI)

/datum/robolimb/bishop
	company = "Bishop"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_main.dmi'
	unavailable_at_fab = 1

/datum/robolimb/bishop/rook
	company = "Bishop Rook"
	desc = "This limb has a polished metallic casing and a holographic face emitter."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_rook.dmi'
	has_eyes = FALSE
	unavailable_at_fab = 1

/datum/robolimb/bishop/alt
	company = "Bishop Alt."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_alt.dmi'
	applies_to_part = list(BP_HEAD)
	unavailable_at_fab = 1

/datum/robolimb/bishop/alt/monitor
	company = "Bishop Monitor."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_monitor.dmi'
	allowed_bodytypes = list(SPECIES_IPC)
	unavailable_at_fab = 1

/datum/robolimb/hephaestus
	company = "Hephaestus Industries"
	desc = "This limb has a militaristic black and green casing with gold stripes."
	icon = 'icons/mob/human_races/cyberlimbs/hephaestus/hephaestus_main.dmi'
	unavailable_at_fab = 1

/datum/robolimb/hephaestus/alt
	company = "Hephaestus Alt."
	icon = 'icons/mob/human_races/cyberlimbs/hephaestus/hephaestus_alt.dmi'
	applies_to_part = list(BP_HEAD)
	unavailable_at_fab = 1

/datum/robolimb/hephaestus/titan
	company = "Hephaestus Titan"
	desc = "This limb has a casing of an olive drab finish, providing a reinforced housing look."
	icon = 'icons/mob/human_races/cyberlimbs/hephaestus/hephaestus_titan.dmi'
	has_eyes = FALSE
	unavailable_at_fab = 1

/datum/robolimb/hephaestus/alt/monitor
	company = "Hephaestus Monitor."
	icon = 'icons/mob/human_races/cyberlimbs/hephaestus/hephaestus_monitor.dmi'
	allowed_bodytypes = list(SPECIES_IPC)
	can_eat = null
	unavailable_at_fab = 1

/datum/robolimb/zenghu
	company = "Zeng-Hu"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_main.dmi'
	can_eat = 1
	unavailable_at_fab = 1
	allowed_bodytypes = list(SPECIES_HUMAN,SPECIES_IPC)

/datum/robolimb/zenghu/spirit
	company = "Zeng-Hu Spirit"
	desc = "This limb has a sleek black and white polymer finish."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_spirit.dmi'
	unavailable_at_fab = 1

/datum/robolimb/xion
	company = "Xion"
	desc = "This limb has a minimalist black and red casing."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_main.dmi'

/datum/robolimb/xion/econo
	company = "Xion Econ"
	desc = "This skeletal mechanical limb has a minimalist black and red casing."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_econo.dmi'
	unavailable_at_fab = 1

/datum/robolimb/xion/alt
	company = "Xion Alt."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_alt.dmi'
	applies_to_part = list(BP_HEAD)
	unavailable_at_fab = 1

/datum/robolimb/xion/alt/monitor
	company = "Xion Monitor."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_monitor.dmi'
	allowed_bodytypes = list(SPECIES_IPC)
	can_eat = null
	unavailable_at_fab = 1

/datum/robolimb/nanotrasen
	company = "NanoTrasen"
	desc = "This limb is made from a cheap polymer."
	icon = 'icons/mob/human_races/cyberlimbs/nanotrasen/nanotrasen_main.dmi'

/datum/robolimb/wardtakahashi
	company = "Ward-Takahashi"
	desc = "This limb features sleek black and white polymers."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	can_eat = 1
	unavailable_at_fab = 1

/datum/robolimb/economy
	company = "Ward-Takahashi Econ."
	desc = "A simple robotic limb with retro design. Seems rather stiff."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_economy.dmi'

/datum/robolimb/wardtakahashi/alt
	company = "Ward-Takahashi Alt."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_alt.dmi'
	applies_to_part = list(BP_HEAD)
	unavailable_at_fab = 1

/datum/robolimb/wardtakahashi/alt/monitor
	company = "Ward-Takahashi Monitor."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_monitor.dmi'
	allowed_bodytypes = list(SPECIES_IPC)
	can_eat = null
	unavailable_at_fab = 1

/datum/robolimb/morpheus
	company = "Morpheus"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_main.dmi'
	unavailable_at_fab = 1

/datum/robolimb/morpheus/alt
	company = "Morpheus Atlantis"
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_atlantis.dmi'
	applies_to_part = list(BP_HEAD)
	unavailable_at_fab = 1

/datum/robolimb/morpheus/alt/blitz
	company = "Morpheus Blitz"
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_blitz.dmi'
	applies_to_part = list(BP_HEAD)
	has_eyes = FALSE
	unavailable_at_fab = 1

/datum/robolimb/morpheus/alt/airborne
	company = "Morpheus Airborne"
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_airborne.dmi'
	applies_to_part = list(BP_HEAD)
	has_eyes = FALSE
	unavailable_at_fab = 1

/datum/robolimb/morpheus/alt/prime
	company = "Morpheus Prime"
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_prime.dmi'
	applies_to_part = list(BP_HEAD)
	has_eyes = FALSE
	unavailable_at_fab = 1

/datum/robolimb/mantis
	company = "Morpheus Mantis"
	desc = "This limb has a casing of sleek black metal and repulsive insectile design."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_mantis.dmi'
	unavailable_at_fab = 1
	has_eyes = FALSE

/datum/robolimb/morpheus/monitor
	company = "Morpheus Monitor."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_monitor.dmi'
	applies_to_part = list(BP_HEAD)
	unavailable_at_fab = 1
	has_eyes = FALSE
	allowed_bodytypes = list(SPECIES_IPC)

/datum/robolimb/veymed
	company = "Vey-Med"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon = 'icons/mob/human_races/cyberlimbs/veymed/veymed_main.dmi'
	can_eat = 1
	skintone = 1
	unavailable_at_fab = 1
	species_cannot_use = list(SPECIES_IPC)

/datum/robolimb/shellguard
	company = "Shellguard"
	desc = "This limb has a sturdy and heavy build to it."
	icon = 'icons/mob/human_races/cyberlimbs/shellguard/shellguard_main.dmi'

/datum/robolimb/shellguard/alt
	company = "Shellguard Alt."
	icon = 'icons/mob/human_races/cyberlimbs/shellguard/shellguard_alt.dmi'
	applies_to_part = list(BP_HEAD)
	unavailable_at_fab = 1

/datum/robolimb/shellguard/alt/monitor
	company = "Shellguard Monitor."
	icon = 'icons/mob/human_races/cyberlimbs/shellguard/shellguard_monitor.dmi'
	applies_to_part = list(BP_HEAD)
	unavailable_at_fab = 1
	allowed_bodytypes = list(SPECIES_IPC)

/datum/robolimb/vox
	company = "Arkmade"
	icon = 'icons/mob/human_races/cyberlimbs/vox/primalis.dmi'
	unavailable_at_fab = 1
	allowed_bodytypes = list(SPECIES_VOX)
	species_cannot_use = list(SPECIES_VOX_ARMALIS)

/datum/robolimb/vox/crap
	company = "Improvised"
	icon = 'icons/mob/human_races/cyberlimbs/vox/improvised.dmi'
