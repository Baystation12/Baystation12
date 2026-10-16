/datum/power/cosmic_cult/malign_glare
	name = "Malign Glare"
	desc = "Emit a horrid pulse of cosmic light, slowing and disorienting everyone around you. Its effects are amplified against silicon-based entities."
	ability_icon_state = "glare"
	innate_power = TRUE // DEBUG
	cooldown = 40 SECONDS
	var/datum/callback/callback

/datum/power/cosmic_cult/malign_glare/New()
	. = ..()

	callback = new Callback(src, TYPE_PROC_REF(/datum/power/cosmic_cult/malign_glare, flash_test))

/datum/power/cosmic_cult/malign_glare/proc/flash_test(mob/living/O)
	return !is_cosmic_cultist(O)

/datum/power/cosmic_cult/malign_glare/execute(datum/cosmic_cultist/cultist, datum/action/cosmic_cult/action)
	cosmic_cult_glare_vfx(cultist.owning_mind.current)
	do_area_flash(cultist.owning_mind.current, 8, 15, FLASH_PROTECTION_MODERATE, callback)

	for(var/obj/machinery/light/L in view(8, cultist.owning_mind.current))
		L.on = 1
		L.broken()

	return TRUE
