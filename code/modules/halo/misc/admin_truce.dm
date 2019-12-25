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
	var/do_message = alert(user,"Do you want to show the worldwide alert? (Choose no if refreshing invicibility or stealth-disabling)","Show Message?","Yes","No")
	var/message = ""
	if(truce_active)
		message = "The truce has ended. Return to your assigned ships and get ready to finish the fight."
		toggle_truce(0)
	else
		message = "A faction wide truce has been enacted."
		toggle_truce(1)
	if(do_message == "Yes")
		to_world("<span class = 'danger'>[message]</span>")
	else
		to_chat(user,"<span class = 'notice'>[message]</span>")
	truce_active = !truce_active