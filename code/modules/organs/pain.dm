mob/proc/flash_pain()
	flick("pain",pain)

mob/var/last_pain_message
mob/var/next_pain_time = 0

// message is the custom message to be displayed
// power decides how much painkillers will stop the message
// force means it ignores anti-spam timer
mob/living/carbon/proc/custom_pain(var/message, var/power, var/force, var/obj/item/organ/external/affecting, var/nohalloss)
	if(!message || stat || !can_feel_pain() || chem_effects[CE_PAINKILLER] > power)
		return 0

	// Excessive halloss is horrible, just give them enough to make it visible.
	if(!nohalloss && power)
		if(affecting)
			affecting.add_pain(ceil(power/2))
		else
			adjustHalLoss(ceil(power/2))

	// Anti message spam checks
	if(force || (message != last_pain_message) || (world.time >= next_pain_time))
		last_pain_message = message
		if(power >= 50)
			to_chat(src, "<span class='danger'><font size=3>[message]</font></span>")
		else if(power >= 10)
			to_chat(src, "<span class='danger'>[message]</span>")
		else
			to_chat(src, "<span class='warning'>[message]</span>")
	next_pain_time = world.time + (100-power)

mob/living/carbon/human/proc/handle_pain()
	if(stat)
		return
	if(!can_feel_pain())
		return
	if(world.time < next_pain_time)
		return
	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in organs)
		if(!E.can_feel_pain()) continue
		var/dam = E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ && chem_effects[CE_PAINKILLER] < maxdam)
		if(maxdam > 10 && paralysis)
			paralysis = max(0, paralysis - round(maxdam/10))
		if(maxdam > 50 && prob(maxdam / 5))
			drop_item()
		var/burning = damaged_organ.burn_dam > damaged_organ.brute_dam
		var/msg
		switch(maxdam)
			if(1 to 10)
				msg =  "Your [damaged_organ.name] [burning ? "burns" : "hurts"]."
			if(11 to 90)
				flash_weak_pain()
				msg = "<font size=2>Your [damaged_organ.name] [burning ? "burns" : "hurts"] badly!</font>"
			if(91 to 10000)
				flash_pain()
				msg = "<font size=3>OH GOD! Your [damaged_organ.name] is [burning ? "on fire" : "hurting terribly"]!</font>"
		custom_pain(msg, 0, prob(10), affecting = damaged_organ)

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/internal/I in internal_organs)
		if(prob(1) && !((I.status & ORGAN_DEAD) || I.robotic >= ORGAN_ROBOT) && I.damage > 5)
			var/obj/item/organ/external/parent = get_organ(I.parent_organ)
			var/pain = 10
			var/message = "You feel a dull pain in your [parent.name]"
			if(I.is_bruised())
				pain = 25
				message = "You feel a pain in your [parent.name]"
			if(I.is_broken())
				pain = 50
				message = "You feel a sharp pain in your [parent.name]"
			src.custom_pain(message, pain, affecting = parent)


	if(prob(1))
		switch(getToxLoss())
			if(5 to 17)
				custom_pain("Your body stings slightly.", getToxLoss())
			if(17 to 35)
				custom_pain("Your body stings.", getToxLoss())
			if(35 to 60)
				custom_pain("Your body stings strongly.", getToxLoss())
			if(60 to 100)
				custom_pain("Your whole body hurts badly.", getToxLoss())
			if(100 to INFINITY)
				custom_pain("Your body aches all over, it's driving you mad.", getToxLoss())