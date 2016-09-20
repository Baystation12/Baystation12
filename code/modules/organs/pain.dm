mob/proc/flash_pain()
	flick("pain",pain)

mob/var/list/pain_stored = list()
mob/var/last_pain_message = ""
mob/var/next_pain_time = 0

// partname is the name of a body part
// amount is a num from 1 to 100
mob/living/carbon/proc/pain(var/partname, var/amount, var/force, var/burning = 0)
	if(!can_feel_pain())
		return
	if(chem_effects[CE_PAINKILLER] > amount)
		return
	if(world.time < next_pain_time && !force)
		return
	if(amount > 10 && istype(src,/mob/living/carbon/human))
		if(src:paralysis)
			src:paralysis = max(0, src:paralysis-round(amount/10))
	if(amount > 50 && prob(amount / 5))
		drop_item()
	var/msg
	if(burning)
		switch(amount)
			if(1 to 10)
				msg = "Your [partname] burns."
			if(11 to 90)
				flash_weak_pain()
				msg = "<font size=2>Your [partname] burns badly!</font>"
			if(91 to 10000)
				flash_pain()
				msg = "<font size=3>OH GOD! Your [partname] is on fire!</font>"
	else
		switch(amount)
			if(1 to 10)
				msg = "Your [partname] hurts."
			if(11 to 90)
				flash_weak_pain()
				msg = "<font size=2>Your [partname] hurts badly.</font>"
			if(91 to 10000)
				flash_pain()
				msg = "<font size=3>OH GOD! Your [partname] is hurting terribly!</font>"
	custom_pain(msg, amount, force || prob(10))

// message is the custom message to be displayed
// power decides how much painkillers will stop the message
// force means it ignores anti-psam timer
mob/living/carbon/proc/custom_pain(message, power, force)
	if(stat)
		return 0
	if(!message)
		return
	if(!can_feel_pain())
		return
	if(chem_effects[CE_PAINKILLER] > power)
		return
	message = "<span class='danger'>[message]</span>"
	if(power >= 50)
		message = "<font size=3>[message]</font>"

	// Anti message spam checks
	if(force || (message != last_pain_message) || (world.time >= next_pain_time))
		last_pain_message = message
		src << message
	next_pain_time = world.time + (100-power)

mob/living/carbon/human/proc/handle_pain()
	if(stat)
		return
	if(!can_feel_pain())
		return
	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in organs)
		if((E.status & ORGAN_DEAD) || E.robotic >= ORGAN_ROBOT) continue
		var/dam = E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ)
		pain(damaged_organ.name, maxdam, 0)

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/I in internal_organs)
		if((I.status & ORGAN_DEAD) || I.robotic >= ORGAN_ROBOT) continue
		if(I.damage > 2) if(prob(2))
			var/obj/item/organ/external/parent = get_organ(I.parent_organ)
			src.custom_pain("You feel a sharp pain in your [parent.name]", 50)

	if(prob(2))
		switch(getToxLoss())
			if(1 to 10)
				custom_pain("Your body stings slightly.", getToxLoss())
			if(11 to 60)
				custom_pain("Your whole body hurts badly.", getToxLoss())
			if(61 to INFINITY)
				custom_pain("Your body aches all over, it's driving you mad.", getToxLoss())