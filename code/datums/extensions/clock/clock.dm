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

/datum/extension/clock/proc/toggle24()
	hour24 = !hour24

/atom/proc/check_watch(var/clock_name in get_clocks())
	set name = "Check Watch"
	set category = "Object"
	set src in usr

	if (usr.incapacitated())
		return
	var/datum/extension/clock/C = get_clocks()[clock_name]
	if (!C)
		return
	C.do_check()

/atom/proc/calibrate_watch(var/clock_name in get_clocks())
	set name = "Calibrate Watch"
	set category = "Object"
	set src in usr

	if (usr.incapacitated())
		return
	var/datum/extension/clock/C = get_clocks()[clock_name]
	if (!C)
		return
	C.do_calibrate()

/datum/extension/clock/proc/do_check()
	var/mob/user = usr
	var/obj/H = holder
	if (in_range(holder, user))
		user.visible_message("<span class='notice'>[user] \
			[pick("glances at", "checks", "consults", "looks at", "studies", "contemplates", \
			"considers", "observes", "eyes", "views", "eyeballs", "takes a look at", \
			"takes a glance at", "takes a gander at")] \
			their [H.name].</span>","<span class='notice'>You check your [H.name].</span>")
		if (!digital && ishuman(user))
			var/mob/living/carbon/human/user_human = user
			if (user_human.getBrainLoss() > 15 || prob(user.skill_fail_chance(SKILL_BUREAUCRACY, 100, SKILL_BASIC)))
				to_chat(user, "Wait, where are the numbers? What is this, \
					[rand(game_year-200,game_year-400)]? What a piece of junk.")
				return
		to_chat(user, "[digital ? "The display reads" : "The hands show"]: [readout()]")

/datum/extension/clock/proc/readout()
	var/time_to_show = station_time_in_ticks + inaccuracy
	// sorry, dumb hack here to avoid doing an hour modulus before taking time2text
	// if i did it while it was still a number, that would make it inaccurate on any non-GMT host
	var/hours = text2num(time2text(time_to_show,"hh"))
	var/minutes = time2text(time_to_show,"mm")
	var/ampm = ""
	if (!hour24)
		if (digital)
			ampm = hours > 12 ? " PM" : " AM"
		hours %= 12
		if (hours == 0) // midnight is 12 on a 12 hour clock
			hours = "12"
		else if (digital && hours < 10) // leading zero for hours on digital clock
			hours = "0[hours]"
	return "[hours]:[minutes][ampm]"

/datum/extension/clock/proc/do_calibrate()
	var/mob/user = usr
	if (do_after(user, (digital ? 20 : 80), holder))
		var/obj/H = holder
		user.visible_message("<span class='notice'>[user] adjusts their [H.name].</span>", \
			"<span>You adjust your [H.name]. Perfect!</span>")
		if (inaccuracy > 30 MINUTES)
			inaccuracy = 30 MINUTES
		inaccuracy *= 2 * (rand() - 0.5) * (0.1 * user.skill_fail_chance(SKILL_BUREAUCRACY, 30, SKILL_MAX))

/atom/proc/get_clocks()
	. = list()
	if (has_extension(src, /datum/extension/clock))
		.[name] = get_extension(src, /datum/extension/clock)

/obj/item/clothing/under/get_clocks()
	. = ..()
	var/clock_accessories_by_name = list()
	for (var/obj/accessory in accessories)
		if (has_extension(accessory, /datum/extension/clock))
			group_by(clock_accessories_by_name , accessory.name, accessory)

	for (var/accessory_name in clock_accessories_by_name)
		var/list/clock_accessories = clock_accessories_by_name[accessory_name]
		if (clock_accessories.len == 1)
			.[accessory_name] = get_extension(clock_accessories[1], /datum/extension/clock)
		else
			for (var/i = 1 to clock_accessories.len)
				var/clock_name = "[accessory_name] [i]"
				.[clock_name] = get_extension(clock_accessories[i], /datum/extension/clock)

/obj/item/weapon/watch/get_clocks()
	var/clock_items_by_name = list()
	for (var/obj/item/I in list(
		/obj/item/weapon/watch,
		/obj/item/weapon/watch/digital,
		/obj/item/weapon/watch/spaceman,
		/obj/item/weapon/watch/fancy,
	))
		group_by(clock_items_by_name, I.name, I)

	for (var/item_name in clock_items_by_name)
		var/list/clock_items = clock_items_by_name[item_name]
		if (clock_items.len == 1)
			.[item_name] = get_extension(clock_items[1], /datum/extension/clock)
		else
			for (var/i = 1 to clock_items.len)
				var/clock_name = "[item_name] [i]"
				.[clock_name] = get_extension(clock_items[i], /datum/extension/clock)