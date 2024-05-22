// =================================================================
// RESOMI UNIT TESTS
// =================================================================

/mob/living/carbon/human/resomi/Initialize(mapload)
	head_hair_style = "Resomi Plumage"
	. = ..(mapload, SPECIES_RESOMI)

/datum/unit_test/mob_damage/resomi
	name = "MOB: Resomi damage check template"
	template = /datum/unit_test/mob_damage/resomi
	mob_type = /mob/living/carbon/human/resomi

/datum/unit_test/mob_damage/resomi/brute
	name = "MOB: Resomi Brute Damage Check"
	damagetype = DAMAGE_BRUTE
	expected_vulnerability = EXTRA_VULNERABLE

/datum/unit_test/mob_damage/resomi/fire
	name = "MOB: Resomi Fire Damage Check"
	damagetype = DAMAGE_BURN
	expected_vulnerability = EXTRA_VULNERABLE

/datum/unit_test/mob_damage/resomi/tox
	name = "MOB: Resomi Toxins Damage Check"
	damagetype = DAMAGE_TOXIN

/datum/unit_test/mob_damage/resomi/oxy
	name = "MOB: Resomi Oxygen Damage Check"
	damagetype = DAMAGE_OXY

/datum/unit_test/mob_damage/resomi/genetic
	name = "MOB: Resomi Genetic Damage Check"
	damagetype = DAMAGE_GENETIC

/datum/unit_test/mob_damage/resomi/pain
	name = "MOB: Resomi Pain Damage Check"
	damagetype = DAMAGE_PAIN
