/datum/power/cosmic_cult/shift
	name = "Astral Shift"
	desc = "Slip out of phase with realspace in order to access the cosmic dark."
	ability_icon_state = "shift"
	innate_power = TRUE
	cooldown = 55 SECONDS

/datum/cosmic_cultist
	var/turf/return_to

/datum/power/cosmic_cult/shift/execute(datum/cosmic_cultist/cultist, datum/action/cosmic_cult/action)
	var/mob/target = cultist.owning_mind.current
	if (istype(get_area(target), /area/cosmic_dark))
		return FALSE

	cultist.return_to = cultist.owning_mind.current.loc
	var/turf/entry = pick(GLOB.cosmic_dark_entries)

	cosmic_cult_shift_vfx(target)
	cosmic_cult_sink_out(target)
	sleep(2 SECONDS)

	target.forceMove(entry)
	cosmic_cult_shift_vfx(target)
	sleep(1 SECONDS)
	cosmic_cult_sink_in(target)

	cultist.grant_power(/datum/power/cosmic_cult/astral_return)
	return TRUE
