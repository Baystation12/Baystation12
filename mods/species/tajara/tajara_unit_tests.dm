// =================================================================
// TAJARA UNIT TESTS
// =================================================================
/datum/unit_test/mob_damage/tajara
	name = "MOB: Tajara damage check template"
	template = /datum/unit_test/mob_damage/tajara
	mob_type = /mob/living/carbon/human/tajaran

/datum/unit_test/mob_damage/tajara/brute
	name = "MOB: Tajara Brute Damage Check"
	damagetype = DAMAGE_BRUTE
	expected_vulnerability = EXTRA_VULNERABLE

/datum/unit_test/mob_damage/tajara/fire
	name = "MOB: Tajara Fire Damage Check"
	damagetype = DAMAGE_BURN
	expected_vulnerability = EXTRA_VULNERABLE

/datum/unit_test/mob_damage/tajara/tox
	name = "MOB: Tajara Toxins Damage Check"
	damagetype = DAMAGE_TOXIN

/datum/unit_test/mob_damage/tajara/oxy
	name = "MOB: Tajara Oxygen Damage Check"
	damagetype = DAMAGE_OXY

/datum/unit_test/mob_damage/tajara/genetic
	name = "MOB: Tajara Genetic Damage Check"
	damagetype = DAMAGE_GENETIC

/datum/unit_test/mob_damage/tajara/pain
	name = "MOB: Tajara Pain Damage Check"
	damagetype = DAMAGE_PAIN
