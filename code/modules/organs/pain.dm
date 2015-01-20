mob/proc/flash_pain()
	flick("pain",pain)

mob/var/list/pain_stored = list()
mob/var/last_pain_message = ""
mob/var/next_pain_time = 0

/mob/living/carbon/proc/has_painkiller()
	return (analgesic || reagents.has_reagent("tramadol") || reagents.has_reagent("oxycodone") || reagents.has_reagent("paracetamol"))


// partname is the name of a body part
// amount is a num from 1 to 100
/mob/living/carbon/proc/pain(var/partname, var/amount, var/force, var/burning = 0)
	if(stat >= 2 || has_painkiller())
		return
	if(world.time < next_pain_time && !force)
		return
	if(amount > 10 && istype(src,/mob/living/carbon/human))
		if(src.paralysis)
			src.paralysis = max(0, src.paralysis-round(amount/10))
	if(amount > 50 && prob(amount / 5))
		src:drop_item()
	var/msg
	if(burning)
		switch(amount)
			if(1 to 10)
				msg = "<span class='danger'>Your [partname] burns.</span>"
			if(11 to 90)
				flash_weak_pain()
				msg = "<span class='danger'><font size=2>Your [partname] burns badly!</font></span>"
			if(91 to 10000)
				flash_pain()
				msg = "<span class='danger'><font size=3>OH GOD! Your [partname] is on fire!</font></span>"
	else
		switch(amount)
			if(1 to 10)
				msg = "<span class='danger'>Your [partname] hurts.</span>"
			if(11 to 90)
				flash_weak_pain()
				msg = "<span class='danger'><font size=2>Your [partname] hurts badly.</font></span>"
			if(91 to 10000)
				flash_pain()
				msg = "<span class='danger'><font size=3>OH GOD! Your [partname] is hurting terribly!</font></span>"
	if(msg && (msg != last_pain_message || prob(10)))
		last_pain_message = msg
		src << msg
	next_pain_time = world.time + (100 - amount)


// message is the custom message to be displayed
// flash_strength is 0 for weak pain flash, 1 for strong pain flash
/mob/living/carbon/human/proc/custom_pain(var/message, var/flash_strength)
	if(stat >= 1) return

	if(species && species.flags & NO_PAIN) return

	if(has_painkiller())
		return

	var/msg = "<span class='danger'>[message]</span>"
	if(flash_strength >= 1)
		msg = "<span class='danger'><font size=3>[message]</font></span>"

	// Anti message spam checks
	if(msg && ((msg != last_pain_message) || (world.time >= next_pain_time)))
		last_pain_message = msg
		src << msg
	next_pain_time = world.time + 100

/mob/living/carbon/human/proc/handle_pain()

	if(stat >= 2 || (species && (species.flags & NO_PAIN)))
		return
	if(has_painkiller())
		return

	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in organs)
		// amputated limbs don't cause pain
		if(E.amputated) continue
		if(E.status & ORGAN_DEAD) continue
		var/dam = E.is_damaged()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ)
		pain(damaged_organ.name, maxdam, 0)

	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/internal/I in internal_organs)
		if(I.is_damaged() && prob(2))
			var/obj/item/organ/external/parent = get_organ(I.parent_organ)
			src.custom_pain("You feel a sharp pain in your [parent.name].", 1)

	switch(getToxLoss())
		if(1 to 5)
			if(prob(1)) src.custom_pain("Your body stings slightly.", getToxLoss() >= 15)
		if(6 to 10)
			if(prob(2)) src.custom_pain("Your whole body hurts a little.", getToxLoss() >= 15)
		if(11 to 15)
			if(prob(2)) src.custom_pain("<span class='warning'>Your whole body hurts...</span>", getToxLoss() >= 15)
		if(15 to 25)
			if(prob(3)) src.custom_pain("<span class='warning'>Your whole body hurts badly...</span>", getToxLoss() >= 15)
		if(26 to INFINITY)
			if(prob(5)) src.custom_pain("<span class='danger'>Your body aches all over. It's driving you mad!</span>", getToxLoss() >= 15)