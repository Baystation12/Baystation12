
/datum/armourspecials/cloaking
	var/cloak_active = 0
	var/min_alpha = 10 //The minimum level of alpha to reach.
	var/cloak_recover_time = 5 //The time in seconds it takes to recover to full cloak after being hit.
	var/cloak_toggle_time = 2 //The time in seconds it takes to enable/disable the cloaking device.
	var/cloak_disrupted = 0 //Is the cloak currently disrupted?

/datum/armourspecials/cloaking/proc/activate_cloak(var/voluntary = 1)
	src.cloak_active = 1
	animate(user,alpha = min_alpha,time = (cloak_toggle_time SECONDS),flags = ANIMATION_END_NOW)
	if(cloak_disrupted)//This stops span from cloak disruption, but still applies the affects.
		return
	if(voluntary)
		user.visible_message("<span class = 'warning'>[user] activates their active camoflage</span>")
	else
		to_chat(user,"<span class = 'danger'>Your active camoflage recovers!</span>")
		user.visible_message("<span calss = 'warning'>[user]'s active camoflage lets out a soft ping and [user] starts to fade.</span>")

/datum/armourspecials/cloaking/proc/deactivate_cloak(var/voluntary = 1)
	src.cloak_active = 0
	animate(user,alpha = 255,time = (cloak_toggle_time SECONDS),flags = ANIMATION_END_NOW)
	if(cloak_disrupted)//This stops span from cloak disruption, but still applies the affects.
		return
	if(voluntary)
		user.visible_message("<span class = 'warning'>[user] deactivates their active camoflage</span>")
	else
		to_chat(user,"<span class = 'danger'>Your active camoflage fails!</span>")
		user.visible_message("<span class = 'warning'>[user]'s active camoflage sputters and fails!</span>")

/datum/armourspecials/cloaking/proc/disrupt_cloak(var/disrupt_time = cloak_recover_time)
	if(!src.cloak_active)
		return
	src.cloak_disrupted = 1
	deactivate_cloak(0)
	spawn(disrupt_time SECONDS)
		activate_cloak(0)
		src.cloak_disrupted = 0

/datum/armourspecials/cloaking/try_item_action()
	if(!cloak_active)
		if(cloak_disrupted)
			to_chat(user,"<span class = 'warning'>You can't re-enable your cloak whilst it's being disrupted.</span>")
			return
		activate_cloak()
	else
		deactivate_cloak()

/datum/armourspecials/cloaking/handle_shield(mob/m,damage,atom/damage_source)
	disrupt_cloak()
	return 0

/datum/armourspecials/cloaking/tryemp(severity)
	switch(severity)
		if(1)
			disrupt_cloak(cloak_recover_time*2)
		if(2)
			disrupt_cloak(cloak_recover_time*4)
