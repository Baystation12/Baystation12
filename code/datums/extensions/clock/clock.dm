/datum/extension/clock
	base_type = /datum/extension/clock
	var/digital = FALSE
	var/hour24 = FALSE
	var/inaccuracy = 0

/datum/extension/clock/New(holder, digital, hour24, inaccuracy)
	..()
	src.digital    = digital
	src.hour24     = hour24
	src.inaccuracy = inaccuracy * 2 * rand() * (rand() - 0.5) // inaccurate on a curve between -i min and +i min

/datum/extension/clock/proc/check(mob/user)
	if (in_range(holder, user))
		if (!digital && ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.getBrainLoss() > 15 || prob(user.skill_fail_chance(SKILL_BUREAUCRACY, 100, SKILL_BASIC)))
				to_chat(user, "Wait, where are the numbers? What is this, \
					[rand(game_year-200,game_year-400)]? What a piece of junk.")
				return
		to_chat(user, "[digital ? "The display reads" : "The hands show"]: [readout()]")

/datum/extension/clock/proc/toggle24()
	hour24 = !hour24

/datum/extension/clock/proc/readout()
	var/time_to_show = station_time_in_ticks + inaccuracy
	// sorry, dumb hack here to avoid doing an hour modulus before taking time2text
	// if i did it while it was still a number, that would make it inaccurate on any non-GMT host
	var/hours = text2num(time2text(time_to_show,"hh"))
	var/minutes = time2text(time_to_show,"mm")
	var/ampm = ""
	if (!hour24)
		ampm = hours > 12 ? " PM" : " AM"
		hours %= 12
		if (hours == 0) // midnight is 12 on a 12 hour clock
			hours = "12"
		else if (digital && hours < 10) // leading zero for hours on digital clock
			hours = "0[hours]"
	return "[hours]:[minutes][ampm]"

/datum/extension/clock/proc/check_verb(mob/user)
	user.visible_message("<span class='notice'>[user] \
		[pick("glances at", "checks", "consults", "looks at", "studies", "contemplates", \
		"considers", "observes", "eyes", "views", "eyeballs", "takes a look at", \
		"takes a glance at", "takes a gander at")] \
		their [holder.name].</span>","<span class='notice'>You check your [holder.name].</span>")
	check(user)

/datum/extension/clock/verb/calibrate_verb(mob/user)
	if (do_after(user, 80 - 60*digital, src))
		user.visible_message("<span class='notice'>[user] adjusts their [holder.name].</span>", \
			"<span>You adjust your [holder.name]. Perfect!</span>")
		if (inaccuracy > 30 MINUTES)
			inaccuracy = 30 MINUTES
		inaccuracy *= 2 * (rand() - 0.5) * (0.1 * user.skill_fail_chance(SKILL_BUREAUCRACY, 20, SKILL_MAX))