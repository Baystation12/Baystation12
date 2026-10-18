/datum/power/cosmic_cult/lapse
	name = "Astral Lapse"
	desc = "Lapse your target's corporeal form, temporarily rendering it immutable, impassible, and frozen in place."
	ability_icon_state = "lapse"
	innate_power = TRUE // debug
	cooldown = 45 SECONDS
	var/static/list/lapse_forms = alist(
		SPECIES_HUMAN = /mob/living/cosmic_cult/lapse/human,
		SPECIES_UNATHI = /mob/living/cosmic_cult/lapse/unathi,
		SPECIES_VOX = /mob/living/cosmic_cult/lapse/vox,
		SPECIES_DIONA = /mob/living/cosmic_cult/lapse/diona,
		SPECIES_MACHINE = /mob/living/cosmic_cult/lapse/machine,
		SPECIES_ADHERENT = /mob/living/cosmic_cult/lapse/large/adherent,
		SPECIES_SKRELL = /mob/living/cosmic_cult/lapse/large/skrell,
		SPECIES_NABBER = /mob/living/cosmic_cult/lapse/large/nabber,
	)

/datum/power/cosmic_cult/lapse/can_target(atom/A)
	return !is_cosmic_cultist(A) && ishuman(A)

/datum/power/cosmic_cult/lapse/execute(datum/cosmic_cultist/cultist, datum/action/cosmic_cult/action)
	var/mob/living/carbon/human/target = get_target(cultist)
	if (!istype(target))
		return FALSE

	cosmic_cult_lapse_vfx(target)
	var/turf/spawn_on_turf = get_turf(target)
	var/T = lapse_forms[target.species.name] || /mob/living/cosmic_cult/lapse
	var/mob/living/cosmic_cult/lapse/lapsed = new T(spawn_on_turf)
	target.forceMove(lapsed)

	addtimer(new Callback(src, TYPE_PROC_REF(/datum/power/cosmic_cult/lapse, restore), target, spawn_on_turf, lapsed), 15 SECONDS)
	return TRUE

/datum/power/cosmic_cult/lapse/proc/restore(mob/living/carbon/human/target, turf/spawn_on_turf, mob/living/cosmic_cult/lapse/lapsed)
	cosmic_cult_lapse_vfx(lapsed)
	target.forceMove(spawn_on_turf)
	qdel(lapsed)
