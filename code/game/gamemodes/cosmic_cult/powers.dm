// power that a cosmic cultist can have
/datum/power/cosmic_cult
	// if the power is granted just by virtue of being a cultist
	var/innate_power = FALSE

	// cooldown for the action
	var/cooldown

// executes the power
/datum/power/cosmic_cult/proc/execute(datum/cosmic_cultist/cultist, datum/action/cosmic_cult/action)
	return FALSE

// gets a target
/datum/power/cosmic_cult/proc/get_target(datum/cosmic_cultist/cultist)
	if (isnull(cultist.owning_mind.current))
		return

	if (!cultist.owning_mind.current.PushClickHandler(/datum/click_handler/cosmic_cult/pick_target))
		return

	var/datum/click_handler/cosmic_cult/pick_target/CH = cultist.owning_mind.current.click_handlers[1]
	CH.power = src
	var/deadline = world.time + 10 SECONDS
	while (!CH.done && world.time < deadline && !QDELETED(CH))
		sleep(world.tick_lag)
	cultist.owning_mind.current.RemoveClickHandler(CH)

	return CH.picked

// if the actor can perform the power
/datum/power/cosmic_cult/proc/can_perform(mob/M)
	return !M.incapacitated()

// if the actor can reach the atom with the power
/datum/power/cosmic_cult/proc/can_reach(mob/M, atom/A)
	return M.Adjacent(A)

// if the atom is a valid target
/datum/power/cosmic_cult/proc/can_target(atom/A)
	return ismob(A)

// if the atom could be a valid target (superset of can_target)
/datum/power/cosmic_cult/proc/could_target(atom/A)
	return ismob(A)

/datum/action/cosmic_cult
	name = "Cosmic Action Name"
	desc = "Cosmic Action Desc"
	button_icon = 'icons/coscult/cosmic-actions.dmi'
	button_icon_state = "default"
	background_icon_state = "default"
	action_type = AB_INNATE

	var/datum/power/cosmic_cult/power
	var/datum/cosmic_cultist/cultist
	var/cooldown

/datum/action/cosmic_cult/Activate()
	var/ok = power.execute(cultist, src)
	if (ok && !isnull(cooldown))
		cooldown_end = cooldown + world.time
		button?.UpdateIcon()

