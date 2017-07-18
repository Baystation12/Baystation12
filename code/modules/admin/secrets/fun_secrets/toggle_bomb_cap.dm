/datum/admin_secret_item/fun_secret/toggle_bomb_cap
	name = "Toggle Bomb Cap"
	permissions = R_SERVER

/datum/admin_secret_item/fun_secret/toggle_bomb_cap/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	switch(max_explosion_range)
		if(14)	max_explosion_range = 16
		if(16)	max_explosion_range = 20
		if(20)	max_explosion_range = 28
		if(28)	max_explosion_range = 56
		if(56)	max_explosion_range = 128
		if(128)	max_explosion_range = 14
	var/range_dev = max_explosion_range *0.25
	var/range_high = max_explosion_range *0.5
	var/range_low = max_explosion_range
	message_admins("<span class='danger'>[key_name_admin(user)] changed the bomb cap to [range_dev], [range_high], [range_low]</span>", 1)
	log_admin("[key_name_admin(user)] changed the bomb cap to [max_explosion_range]")
