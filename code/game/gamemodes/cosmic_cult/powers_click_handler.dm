/datum/click_handler/cosmic_cult/pick_target
	flags = CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT | CLICK_HANDLER_REMOVE_IF_NOT_TOP | CLICK_HANDLER_REMOVE_ON_CANCEL

	var/atom/picked
	var/datum/power/cosmic_cult/power
	var/done = FALSE

/datum/click_handler/cosmic_cult/pick_target/OnClick(atom/A, params)
	if (power.can_perform(user) && power.can_reach(user, hovered_atom) && power.can_target(hovered_atom))
		picked = A

	done = TRUE

/datum/click_handler/cosmic_cult/pick_target/Exit()
	done = TRUE

/datum/click_handler/cosmic_cult/pick_target/proc/is_reachable(mob/M, atom/A)
	return M == user && power.can_perform(M) && power.can_reach(M, A) && power.can_target(A)
