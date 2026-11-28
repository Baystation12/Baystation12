/datum/power/cosmic_cult/shunt
	name = "Shunt Subjectivity"
	desc = "Shunt your target's mind out of their body and unto the cosmic dark, temporarily rendering their body mindless."
	ability_icon_state = "shunt"
	innate_power = TRUE
	cooldown = 120 SECONDS

/datum/power/cosmic_cult/shunt/can_target(atom/A)
	return !is_cosmic_cultist(A) && ishuman(A)

/datum/power/cosmic_cult/shunt/execute(datum/cosmic_cultist/cultist, datum/action/cosmic_cult/action)
	var/mob/living/carbon/human/target = get_target(cultist)
	var/datum/mind/mind = target.mind
	if (!istype(target) || !istype(mind))
		return FALSE

	if (!do_after(usr, 0.6 SECONDS, target))
		return FALSE

	cosmic_cult_shunt_vfx(target)

	var/turf/entry = pick(GLOB.cosmic_dark_entries)
	var/mob/wisp = new /mob/living/cosmic_cult/wisp(entry)
	mind.transfer_to(wisp)
	cosmic_cult_shunt_vfx(wisp)

	sleep(22 SECONDS)

	var/datum/action/wisp_action = new /datum/action/cosmic_cult/astral_return(target)
	wisp_action.Grant(wisp)
	return TRUE

/datum/action/cosmic_cult/astral_return
	name = "Astral Return"
	desc = "Return back to your body."
	button_icon_state = "return"

/datum/action/cosmic_cult/astral_return/Activate()
	owner.mind?.transfer_to(target)

	var/mob/living/cosmic_cult/wisp/wisp = owner
	if (istype(wisp) && wisp.to_convert)
		var/mob/living/target_mob = target
		GLOB.cosmic_cult.add_antagonist(target_mob.mind, 1, 1)

	cosmic_cult_shunt_vfx(owner)
	qdel(owner)
	qdel(src)
