/client

	var/karma = 0

	var/missiles_fired = 0
	var/missiles_loaded = 0
	var/crewmembers_healed = 0
	var/repairs_made = 0
	var/ghost_activity = 0
	var/damage_dealt = 0
	var/potty_words = 0

	var/last_words
	var/timeofdeath

	proc/get_karma(var/mob/living/carbon/human/body)
		var/new_karma = 0
		var/extra_loaded = missiles_loaded - missiles_fired
		if(extra_loaded > 0)
			new_karma += extra_loaded * 0.5
		new_karma += crewmembers_healed
		new_karma += repairs_made
		if(ghost_activity > 0)
			new_karma += ghost_activity
		else
			new_karma -= ghost_activity
		var/gun_count = 0
		for(var/obj/item/weapon/gun/G in body.contents)
			gun_count += 5
		new_karma -= gun_count
		if(damage_dealt)
			new_karma -= damage_dealt / 10
		new_karma -= potty_words * 0.5

		karma = new_karma
		return new_karma