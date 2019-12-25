/datum/admin_secret_item/fun_secret/enact_truce
	name = "Enact Truce"
	var/truce_active = 0

/datum/admin_secret_item/fun_secret/enact_truce/can_execute(var/mob/user)
	if(!ticker) return 0
	return ..()

/datum/admin_secret_item/fun_secret/enact_truce/proc/toggle_truce(var/on = 0)
	for(var/mob/living/m in world)
		if(on)
			m.status_flags |= GODMODE
		else
			m.status_flags &= GODMODE

/datum/admin_secret_item/fun_secret/enact_truce/execute(var/mob/user)
	if(truce_active)
		to_world("<span class = 'danger'>The truce has ended. Return to your assigned ships and get ready to finish the fight.</span>")
		toggle_truce(0)
	else
		to_world("<span class = 'danger'>A faction wide truce has been enacted.</span>")
		toggle_truce(1)