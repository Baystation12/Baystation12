/datum/power/cosmic_cult/siphon
	name = "Siphon Entropy"
	desc = "Stealthily siphon entropy from your target. Siphoning large amounts of entropy will increase your power."
	ability_icon_state = "siphon"
	innate_power = TRUE
	cooldown = 50 SECONDS

/datum/power/cosmic_cult/siphon/can_target(atom/A)
	return !is_cosmic_cultist(A) && ishuman(A)

/datum/power/cosmic_cult/siphon/execute(datum/cosmic_cultist/cultist, datum/action/cosmic_cult/action)
	var/mob/living/carbon/human/target = get_target(cultist)
	if (!istype(target))
		return FALSE

	if (!do_after(usr, 0.9 SECONDS, target))
		return FALSE

	cosmic_cult_siphon_vfx(target, usr.client)
	return TRUE
