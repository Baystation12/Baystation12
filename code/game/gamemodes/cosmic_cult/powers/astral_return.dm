/datum/power/cosmic_cult/astral_return
	name = "Astral Return"
	desc = "Slip back into phase with realspace to return to where you came from."
	ability_icon_state = "return"
	innate_power = FALSE

/datum/power/cosmic_cult/astral_return/execute(datum/cosmic_cultist/cultist, datum/action/cosmic_cult/action)
	cosmic_cult_shift_vfx(cultist.owning_mind.current)
	cosmic_cult_sink_out(cultist.owning_mind.current)
	sleep(2 SECONDS)

	cultist.owning_mind.current.forceMove(cultist.return_to)
	cosmic_cult_shift_vfx(cultist.owning_mind.current)
	sleep(1 SECONDS)
	cosmic_cult_sink_in(cultist.owning_mind.current)

	cultist.return_to = null

	cultist.revoke_power(/datum/power/cosmic_cult/astral_return)
	return TRUE
