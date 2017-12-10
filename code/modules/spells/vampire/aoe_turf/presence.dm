// Makes the vampire appear 'friendlier' to others.
/spell/aoe_turf/vampire/presence
	set category = "Vampire"
	set name = "Presence (10)"
	set desc = "Influences those weak of mind to look at you in a friendlier light."

/spell/vampire/presence/cast()
	var/datum/vampire/vampire = vampire_power(0, 0)
	if (!vampire)
		return

	if (vampire.status & VAMP_PRESENCE)
		vampire.status &= ~VAMP_PRESENCE
		to_chat(src, "<span class='warning'>You are no longer influencing those weak of mind.</span>")
		return
	else if (vampire.blood_usable < 15)
		to_chat(src, "<span class='warning'>You do not have enough usable blood. 15 needed.</span>")
		return

	to_chat(src, "<span class='notice'>You begin passively influencing the weak minded.</span>")
	vampire.status |= VAMP_PRESENCE

	var/list/mob/living/carbon/human/affected = list()
	var/list/emotes = list("[src] looks trusthworthy.",
							"You feel as if [src] is a relatively friendly individual.",
							"You feel yourself paying more attention to what [src] is saying.",
							"[src] has your best interests at heart, you can feel it.",
							"A quiet voice tells you that [src] should be considered a friend.")

	vampire.use_blood(10)

	log_and_message_admins("activated presence.")

	while (vampire.status & VAMP_PRESENCE)
		// Run every 20 seconds
		sleep(200)

		if (stat)
			to_chat(src, "<span class='warning'>You cannot influence people around you while [stat == 1 ? "unconcious" : "dead"].</span>")
			vampire.status &= ~VAMP_PRESENCE
			break

		for (var/mob/living/carbon/human/T in oview(range))
			if (T == src)
				continue

			if (!vampire_can_affect_target(T, 0, 1))
				continue

			if (!T.client)
				continue

			var/probability = 50
			if (!(T in affected))
				affected += T
				probability = 80

			if (prob(probability))
				to_chat(T, "<font color='green'><i>[pick(emotes)]</i></font>")

		vampire.use_blood(5)

		if (vampire.blood_usable < 5)
			vampire.status &= ~VAMP_PRESENCE
			to_chat(src, "<span class='warning'>You are no longer influencing those weak of mind.</span>")
			break
