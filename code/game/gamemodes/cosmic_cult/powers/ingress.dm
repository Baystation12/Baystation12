/datum/power/cosmic_cult/ingress
	name = "Force Ingress"
	desc = "Use a concentrated blast of power to force a secure doorway open."
	ability_icon_state = "ingress"
	tier = 2
	cooldown = 40 SECONDS

	var/do_after_duration = 0

/datum/power/cosmic_cult/ingress/can_target(atom/A)
	return isairlock(A)

/datum/power/cosmic_cult/ingress/execute(datum/cosmic_cultist/cultist, datum/action/cosmic_cult/action)
	var/obj/machinery/door/airlock/airlock = get_target(cultist)
	if (!istype(airlock))
		return FALSE

	if (!do_after(usr, do_after_duration, airlock))
		return FALSE

	cosmic_cult_ingress_vfx(airlock)

	airlock.unlock(TRUE)
	airlock.open(TRUE)

	return TRUE

/datum/power/cosmic_cult/ingress/colossus
	name = "Colossal Ingress"
	desc = "Use your colossal strength to force open a doorway."
	do_after_duration = 2 SECONDS
	cooldown = 10 SECONDS
	tier = 69
